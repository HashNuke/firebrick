defrecord Domain,
  id: nil,
  name: nil,
  config_type: "domain",
   __errors__: [] do

  use Realm
  use Rinket.RiakRealm


  # Tells the world which bucket this is stored in
  def bucket, do: "rinket_config"

  # These will be skipped when saving
  def skip_attributes, do: ["id"]

  # These will be used for public_attributes
  def safe_attributes, do: ["id", "name"]


  def validate(record) do
    record
    |> validates_length(:name, [min: 1])
  end


  # Override assign_attributes
  # Merge mandatory params and encrypt password if necessary
  def assign_attributes(record, params) do
    super(record, params)
    |> apply(:config_type, ["domain"])
  end

end
