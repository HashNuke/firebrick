defrecord Mail,
  id: nil,
  from: nil,
  to: nil,
  cc: nil,
  date: nil,
  subject: nil,
  reply_to: nil,
  message_id: nil,
  in_reply_to: nil,
  references: nil,
  plain_body: nil,
  html_body: nil,
  raw_data: nil,
   __errors__: [] do

  use Realm
  use Firebrick.RiakRealm


  def bucket, do: "firebrick_mails"


  # These will be skipped when saving
  def skip_attributes, do: ["id"]

  # These will be used for public_attributes
  def safe_attributes, do: [
    "id",
    "from",
    "to",
    "cc",
    "date",
    "subject",
    "reply_to",
    "message_id",
    "in_reply_to",
    :plain_body,
    :html_body,
    "references",
    "raw_data"
  ]


  def validate(record) do
    record
  end


  def accept(mail_fields) do
    mail = parse_mail(mail_fields)
    mail.save
  end


  defp parse_mail({type, sub_type, headers, properties, body}) do
    mail = parse_headers(headers, __MODULE__[])
    |> apply(:sent_as, ["#{type}/#{sub_type}"])
    |> apply(:raw_data, [[
        sent_as: "#{type}/#{sub_type}",
        headers: headers,
        properties: properties,
        body: body
      ]])

    if String.downcase(type) == "text" && String.downcase(sub_type) == "plain" do
      mail.plain_body body
    else
      parse_multipart_body(body, mail)
    end
  end


  defp parse_headers(headers, mail) do
    fields = [
      "from":        :from,
      "to":          :to,
      "cc":          :cc,
      "date":        :date,
      "subject":     :subject,
      "reply-to":    :reply_to,
      "message-id":  :message_id,
      "in-reply-to": :in_reply_to,
      "references":  :references
    ]

    understood_headers = ListDict.keys(fields)

    Enum.reduce(headers, mail, fn({header, value}, modified_mail)->
      downcased_header = String.downcase(header)
      if :lists.member(downcased_header, understood_headers) do
        apply modified_mail, :"#{fields[downcased_header]}", value
      else
        modified_mail
      end
    end)
    |> clean_headers
  end


  defp parse_multipart_body(mail_parts, mail) do
    Enum.reduce(mail_parts, mail, fn({type, sub_type, _headers, _properties, body}, mail)->
      case {String.downcase(type), String.downcase(sub_type)} do
        {"text", "plain"} ->
          mail.plain_body body
        {"text", "html"} ->
          mail.html_body "#{bitstring_to_list(body)}"
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
        [email: "#{address}"]
      else
        [name: "#{name}", email: "#{address}"]
      end
    end)
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
    mail.from parse_address_list(mail.from)
  end


  defp clean_to_field(mail) do
    mail.to parse_address_list(mail.to)
  end


  defp clean_cc_field(mail) do
    if mail.cc do
      mail.cc parse_address_list(mail.cc)
    else
      mail
    end
  end


  defp clean_message_id_field(mail) do
    if mail.message_id do
      #TODO enclose this in a try block
      mail.message_id(parse_message_ids(mail.message_id) |> hd)
    else
      mail
    end
  end


  defp clean_references_field(mail) do
    if mail.references do
      mail.references parse_message_ids(mail.references)
    else
      mail
    end
  end


  defp clean_in_reply_to_field(mail) do
    if mail.in_reply_to do
      mail.in_reply_to(parse_message_ids(mail.in_reply_to) |> hd)
    else
      mail
    end
  end
end
