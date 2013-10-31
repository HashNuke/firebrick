defmodule Rinket.Mail do

  defrecord MailObject, fields: [], raw_data: nil do
    def add_fields(new_fields, mail) do
      mail.fields( ListDict.merge(mail.fields, new_fields) )
    end

    def data(mail) do
      [fields: mail.fields]
    end
  end


  def save(mail_fields) do
    mail = parse_mail(mail_fields)
    obj  = :riakc_obj.new(
      "rinket_mails",
      :undefined,
      :jsx.encode(mail.data),
      "application/json"
    )

    RiakPool.run(fn(worker)->
      :riakc_pb_socket.put(worker, obj)
    end)
    IO.inspect "finally saved ~!"
  end


  defp parse_mail({type, sub_type, headers, properties, body}) do
    mail = parse_headers(headers, MailObject[])

    mail = mail.raw_data([
      type: type,
      sub_type: sub_type,
      headers: headers,
      properties: properties,
      body: body
    ])

    if String.downcase(type) == "text" && String.downcase(sub_type) == "plain" do
      mail.add_fields(["plain_body": body])
    else
      parse_multipart_body(body, mail)
    end
  end


  defp parse_headers(headers, mail) do
    fields = [
      from: "from",
      to: "to",
      cc: "cc",
      subject: "subject",
      date: "date",
      message_id: "message-id",
      reply_to: "reply-to",
      in_reply_to: "in-reply-to",
      references: "references"
    ]

    understood_headers = ListDict.values(fields)

    Enum.reduce(headers, mail, fn({header, value}, modified_mail)->
      downcased_header = String.downcase(header)
      if :lists.member(downcased_header, understood_headers) do
        modified_mail.add_fields(ListDict.put([], downcased_header, value))
      else
        modified_mail
      end
    end)
    |> clean_headers
  end


  defp clean_headers(mail) do
    clean_from_field(mail)
    |> clean_to_field
    |> clean_cc_field
    |> clean_message_id_field
    |> clean_references_field
    |> clean_in_reply_to_field
  end


  defp clean_from_field(mail) do
    mail.add_fields([
      "from": parse_address_list(mail.fields["from"])
    ])
  end


  defp clean_to_field(mail) do
    mail.add_fields([
      "to": parse_address_list(mail.fields["to"])
    ])
  end


  defp clean_cc_field(mail) do
    if mail.fields["cc"] do
      mail.add_fields(["cc": parse_address_list(mail.fields["cc"]) ])
    else
      mail
    end
  end


  defp clean_message_id_field(mail) do
    if mail.fields["message_id"] do
      mail.add_fields([
        "message_id": (parse_message_ids(mail.fields["message_id"]) |> hd)
      ])
    else
      mail
    end
  end


  def clean_references_field(mail) do
    if mail.fields["references"] do
      mail.add_fields([ "references": parse_message_ids(mail.fields["references"]) ])
    else
      mail
    end
  end


  def clean_in_reply_to_field(mail) do
    if mail.fields["in_reply_to"] do
      mail.add_fields([
        "in_reply_to": (parse_message_ids(mail.fields["in_reply_to"]) |> hd)
      ])
    else
      mail
    end
  end


  defp parse_multipart_body(mail_parts, mail) do
    Enum.reduce(mail_parts, mail, fn({type, sub_type, _headers, _properties, body}, mail)->
      case {String.downcase(type), String.downcase(sub_type)} do
        {"text", "plain"} ->
          mail.add_fields(["plain_body": body])
        {"text", "html"} ->
          mail.add_fields(["html_body": "#{bitstring_to_list(body)}"])
        _ -> #TODO cannot parse anything else as of now
          mail
      end
    end)
  end


  defp parse_message_ids(header_value) do
    {:ok, elements} = :smtp_util.parse_rfc822_addresses(header_value)
    Enum.map(elements, fn({name, message_id})->
      message_id
    end)
  end


  defp parse_address_list(address_string) do
    {:ok, addresses} = :smtp_util.parse_rfc822_addresses(address_string)
    Enum.map(addresses, fn({name, address})->
      if name == :undefined do
        [email: address]
      else
        [name: name, email: address]
      end
    end)
  end

end