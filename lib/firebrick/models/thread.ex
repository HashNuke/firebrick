defrecord Thread,
  id: nil,
  subject: nil,
  created_at_dt: nil,
  updated_at_dt: nil,
  message_ids: [],
  mail_previews: [],
  category: nil,
  read: false,
  user_id: nil,
  type: "thread",
  timezone: "+0000",
   __errors__: [] do

  use Realm
  use Firebrick.RiakRealm


  def bucket, do: {"firebrick_type", "firebrick"}
  def index_name, do: "firebrick_index"

  def skip_attributes, do: ["id"]
  def safe_attributes, do: ["id", "subject", "created_at_dt", "updated_at_dt", "read", "mail_previews", "user_id"]


  def assign_timestamps(record) do
    now = timestamp()
    if !record.created_at_dt do
      record = record.created_at_dt(now)
    end
    record.updated_at_dt(now)
  end


  def mark_as_read!(arg1) do
    if is_record(arg1) do
      arg1.read(true).save
    else
      Thread.find(arg1).read(true).save
    end
  end


  def public_attributes(record) do
    fields = ["id", "subject", "created_at_dt", "updated_at_dt", "read", "user_id", "timezone"]
    attrs = lc attr inlist fields do
      { "#{attr}", apply(record, :"#{attr}", []) }
    end

    mail_preview = :lists.last(record.mail_previews)
    # import the function from mail instead of using full reference
    sender = Mail.parse_address_list(mail_preview["sender"]) |> hd
    new_attrs = [
      mail_preview: [sender: sender, preview: mail_preview["preview"]],
      mail_count: length(record.mail_previews)
    ]
    ListDict.merge attrs, new_attrs
  end

end
