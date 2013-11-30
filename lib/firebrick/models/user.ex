defrecord User,
  id: nil,
  username: nil,
  password: nil,
  encrypted_password: nil,
  primary_address: nil,
  first_name: nil,
  last_name: nil,
  role: nil,
  domain_id: nil,
  config_type: "user",
   __errors__: [] do

  use Realm
  use Firebrick.RiakRealm


  # Tells the world which bucket this is stored in
  def bucket, do: {"firebrick_type", "firebrick_config"}
  def index_name, do: "firebrick_index"

  # These will be skipped when saving
  def skip_attributes, do: ["id", "password"]

  # These will be used for public_attributes
  def safe_attributes, do: ["id", "username", "first_name", "last_name", "role", "domain_id", "primary_address"]


  def intercept_obj(record, obj) do
    metadata = :riakc_obj.get_update_metadata(obj)
    |> :riakc_obj.set_secondary_index([ {{:binary_index, "config_type"}, ["user"]} ])
    :riakc_obj.update_metadata(obj, metadata)
  end


  def validate(record) do
    # Validate password for new record OR for an existing record with a password change
    password_validation_condition = fn(record)->
      record.id == nil || (record.id != nil && record.password != nil && record.encrypted_password != nil)
    end

    uniqueness_validation = fn(record)->
      {results, count, _} = User.query("config_type:user AND username:#{record.username}")
      case length(results) do
        0 ->
          true
        1 ->
          result = results |> hd
          result.id == record.id
        _ ->
          false
      end
      true
    end

    #TODO validations should check if the field already has an error
    record
    |> validates_length(:username, [min: 1])
    |> validates_length(:password, [min: 5], password_validation_condition)
    |> validates_length(:first_name, [min: 1])
    |> validates_inclusion(:role, [in: ["admin", "member"]])
    |> validates_uniqueness(:username, [condition: uniqueness_validation])
  end


  def valid_password?(record, password) do
    salt = String.slice(record.encrypted_password, 0, 29)
    {:ok, hashed_password} = :bcrypt.hashpw(password, salt)
    "#{hashed_password}" == record.encrypted_password
  end


  def encrypt_password(record) do
    if record.password != nil do
      {:ok, salt} = :bcrypt.gen_salt()
      {:ok, hashed_password} = :bcrypt.hashpw(record.password, salt)
      record = record.encrypted_password("#{hashed_password}")
    end
    record
  end


  def update_primary_address(record) do
    domain = Domain.find(record.domain_id)
    record.primary_address("#{record.username}@#{domain.name}")
  end


  # Override assign_attributes
  # Merge mandatory params and encrypt password if necessary
  def assign_attributes(record, params) do
    super(record, params)
    |> apply(:config_type, ["user"])
  end


  def before_save(record) do
    record
    |> apply(:encrypt_password, [])
    |> update_primary_address
  end
end
