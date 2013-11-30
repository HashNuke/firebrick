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
  timezone: "+0000",
   __errors__: [] do

  use Realm
  use Firebrick.RiakRealm


  def bucket, do: {"firebrick_type", "firebrick_threads"}
  def index_name, do: "firebrick_index"

  def skip_attributes, do: ["id"]
  def safe_attributes, do: ["id", "subject", "created_at", "updated_at", "read", "mail_previews", "user_id"]


  def intercept_obj(record, obj) do
    user_stamp = "#{record.user_id}_#{:qdate.to_string("Ymdhms", :qdate.parse(record.updated_at))}"
    metadata = :riakc_obj.get_update_metadata(obj)
    metadata = :riakc_obj.set_secondary_index(metadata, [ {{:binary_index, "user_stamp"}, [user_stamp]} ])
    :riakc_obj.update_metadata(obj, metadata)
  end


  def assign_timestamps(record) do
    timestamp = :qdate.to_unixtime({:erlang.date(), :erlang.time()})
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
    fields = ["id", "subject", "created_at", "updated_at", "read", "user_id", "timezone"]
    attrs = lc attr inlist fields do
      { "#{attr}", apply(record, :"#{attr}", []) }
    end

    mail_preview = :lists.last(record.mail_previews)
    # import the function from mail instead of using full reference
    sender = Mail.parse_address_list(mail_preview["sender"]) |> hd
    ListDict.merge attrs, [ mail_preview: [sender: sender, preview: mail_preview["preview"]] ]
  end

end
