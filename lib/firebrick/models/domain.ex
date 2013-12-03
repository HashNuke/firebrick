defrecord Domain,
  id: nil,
  name: nil,
  type: "domain",
   __errors__: [] do

  use Realm
  use Firebrick.RiakRealm


  def bucket, do: {"firebrick_type", "firebrick"}
  def index_name, do: "firebrick_index"

  # These will be skipped when saving
  def skip_attributes, do: ["id"]

  # These will be used for public_attributes
  def safe_attributes, do: ["id", "name"]


  def validate(record) do
    record
    |> validates_length(:name, [min: 1])
  end


  def intercept_obj(record, obj) do
    metadata = :riakc_obj.get_update_metadata(obj)
    |> :riakc_obj.set_secondary_index([ {{:binary_index, "type"}, ["domain"]} ])
    :riakc_obj.update_metadata(obj, metadata)
  end


  # Override assign_attributes
  # Merge mandatory params and encrypt password if necessary
  def assign_attributes(record, params) do
    super(record, params)
    |> apply(:type, ["domain"])
  end

end
