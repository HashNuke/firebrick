defrecord Thread,
  id: nil,
  subject: nil,
  created_at: nil,
  updated_at: nil,
  message_ids: [],
  mail_previews: [],
  category: nil,
  read: false,
  user_id: nil,
   __errors__: [] do

  use Realm
  use Firebrick.RiakRealm


  # Tells the world which bucket this is stored in
  #TODO change this to firebrick_config
  def bucket, do: "firebrick_threads"

  def skip_attributes, do: ["id"]
  def safe_attributes, do: ["id", "subject", "created_at", "updated_at", "read", "mail_previews", "user_id"]


  def assign_timestamps(record) do
    timestamp = :qdate.to_string("Ymdhms", {:erlang.date(), :erlang.time()})
    if !record.created_at do
      record = record.created_at(timestamp)
    end
    record.updated_at(timestamp)
  end


  def mark_as_read!(arg1) do
    if is_record(arg1) do
      arg1.read(true).save
    else
      Thread.find(arg1).read(true).save
    end
  end


  def public_attributes(record) do
    fields = ["id", "subject", "created_at", "updated_at", "read", "user_id"]
    attrs = lc attr inlist fields do
      { "#{attr}", apply(record, :"#{attr}", []) }
    end

    mail_preview = :lists.last(record.mail_previews)
    # import the function from mail instead of using full reference
    sender = Mail.parse_address_list(mail_preview["sender"]) |> hd
    ListDict.merge attrs, [ mail_preview: [sender: sender, preview: mail_preview["preview"]] ]
  end
end
