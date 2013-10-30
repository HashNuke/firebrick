defmodule Rinket.Mail do

  defrecord MailObject, fields: [], raw_data: nil do
    def add_fields(new_fields, mail) do
      mail.fields( ListDict.merge(mail.fields, new_fields) )
    end

    def data(mail) do
      [fields: mail.fields, raw: mail.raw_data]
    end
  end


  def save(mail_fields) do
    IO.inspect "I am here"
    mail = parse_mail(mail_fields)

    obj = :riakc_obj.new(
      "rinket_mails",
      :undefined,
      :jsx.encode(mail.data),
      "application/json"
    )

    RiakPool.run(fn(worker)->
      :riakc_pb_socket.put(worker, obj)
    end)

    IO.inspect "Saving done ~!"
  end


  defp parse_mail({type, sub_type, headers, properties, body}) do
    mail = parse_headers(headers, MailObject)

    mail = mail.raw_data([
      type: type,
      sub_type: sub_type,
      headers: headers,
      properties: properties,
      body: body
    ])

    if String.downcase(type) == "text" && String.downcase(sub_type) == "plain" do
      mail.add_fields([plain_body: body])
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
      message_id: "message-id"
    ]

    Enum.reduce(headers, mail, fn({header, value}, mail)->
      IO.inspect "Inside loop"

      Enum.reduce(fields, mail, fn({field, field_name}, mail)->
        if field_name == String.downcase(header) do
          mail.add_fields(ListDict.put([], field, value))
        else
          mail
        end
      end)
    end)

    mail = mail.add_fields([
      to: parse_address_list(mail.fields[:to]),
      from: parse_address_list(mail.fields[:from])
    ])

    if mail.fields[:cc] do
      mail = mail.add_fields([cc: parse_address_list(mail.fields[:cc]) ])
    end

    mail
  end


  defp parse_multipart_body(mail_parts, mail) do
    Enum.reduce(mail_parts, mail, fn({type, sub_type, _headers, _properties, body}, mail)->
      case {String.downcase(type), String.downcase(sub_type)} do
        {"text", "plain"} ->
          mail.add_fields([plain_body: body])
        {"text", "html"} ->
          mail.add_fields([html_body: body])
        _ -> #TODO cannot parse anything else as of now
          mail
      end
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