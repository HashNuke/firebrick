defrecord Mail,
  id: nil,
  user_id: nil,
  thread_id: nil,
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
  sent_as: nil,
  read: false,
  read_on: nil,
  category: nil,
  parsed_from: nil,
  parsed_to: nil,
  parsed_cc: nil,
  parsed_references: nil,
  raw_data: nil,
  timezone: "+0000",
   __errors__: [] do

  use Realm
  use Firebrick.RiakRealm


  def bucket, do: {"firebrick_type", "firebrick_mails"}
  def index_name, do: "firebrick_index"

  def skip_attributes, do: ["id"]

  def safe_attributes do
    [
      "id",
      "from",
      "to",
      "cc",
      "date",
      "subject",
      "reply_to",
      "message_id",
      "in_reply_to",
      "plain_body",
      "html_body",
      "references",
      "raw_data",
      "category"
    ]
  end


  def validate(record) do
    record
  end


  def mark_as_read!(arg1) do
    timestamp = :qdate.to_unixtime({:erlang.date(), :erlang.time()})
    if is_record(arg1) do
      arg1.read(true).read_on(timestamp).save
    else
      Mail.find(arg1).read(true).read_on(timestamp).save
    end
  end


  def accept(mail_fields) do
    mail = parse_mail(mail_fields)
    current_mail_preview = [sender: mail.from, preview: summarize(mail.plain_body)]

    #TODO categorize spam
    #TODO check for muted threads
    #TODO check if thread is marked as spam
    mail = mail.category("inbox")

    case mail.save do
      {:ok, key} ->

        case mail.thread_id do
          nil ->
            thread = Thread[subject: mail.subject, mail_previews: [current_mail_preview]]
            #TODO append message ids
            thread = thread.assign_timestamps
            thread = thread.user_id(mail.user_id).category(mail.category)
            {:ok, thread_id} = thread.save
            mail.id(key).thread_id(thread_id).save
          _ -> # in this case thread already exists, so only update it
            thread = Thread.find(mail.thread_id)
            thread = thread.mail_previews(thread.mail_previews ++ [current_mail_preview])
            thread = thread.user_id(mail.user_id).category(mail.category)
            thread.assign_timestamps.read(false).save
        end
      _ ->
        #TODO mail wasn't saved
    end
  end


  def summarize(text) do
    {:ok, char_list} = String.to_char_list(text)
    if length(char_list) > 50 do
      "#{Enum.take(char_list, 30)}..."
    else
      "#{Enum.take(char_list, 50)}"
    end
  end


  #TODO Handle errors, bounces
  defp parse_mail({type, sub_type, headers, properties, body}) do
    mail = parse_headers(headers, __MODULE__[])
    receiver_strings = []

    receiver_strings = lc receiver inlist mail.parsed_to do
      "primary_address:#{receiver[:email]}"
    end

    user_query = "config_type:user AND (#{Enum.join(receiver_strings, " OR ")})"
    {users, count} = User.search(user_query)


    if length(users) > 0 do
      mail = mail.user_id hd(users).id
    end

    if mail.parsed_references do
      references_strings = lc reference inlist mail.parsed_references do
        "message_id:<#{reference}> OR message_id:#{reference}"
      end

      thread_query = Enum.join(references_strings, " OR ")
      {threads, count} = Thread.search(thread_query)

      if length(users) > 0 do
        mail = mail.thread_id hd(threads).id
      end
    end


    mail
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
      if :lists.member(:"#{downcased_header}", understood_headers) do
        apply modified_mail, fields[:"#{downcased_header}"], [value]
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


  def parse_address_list(address_string) do
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
    mail
    |> assign_parsed_to_field
    |> assign_parsed_from_field
    |> assign_parsed_cc_field
    |> clean_message_id_field
    |> assign_parsed_references_field
    |> clean_in_reply_to_field
  end


  def assign_parsed_from_field(mail) do
    parse_address_list(mail.from) |> hd |> mail.parsed_from
  end


  def assign_parsed_to_field(mail) do
    mail.parsed_to parse_address_list(mail.to)
  end


  def assign_parsed_cc_field(mail) do
    if mail.parsed_cc do
      mail.parsed_cc parse_address_list(mail.cc)
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


  defp assign_parsed_references_field(mail) do
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
