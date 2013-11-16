defrecord User,
  id: nil,
  username: nil,
  password: nil,
  encrypted_password: nil,
  first_name: nil,
  last_name: nil,
  role: nil,
  config_type: "user",
   __errors__: [] do

  use Realm
  use Rinket.RiakRealm


  # Tells the world which bucket this is stored in
  def bucket, do: "rinket_config"

  # These will be skipped when saving
  def skip_attributes, do: ["id", "password"]

  # These will be used for public_attributes
  def safe_attributes, do: [:id, :username, :first_name, :last_name, :role]


  def validate(record) do
    # Validate password for new record OR for an existing record with a password change
    password_validation_condition = fn(record)->
      record.id == nil || (record.id != nil && record.password != nil && record.encrypted_password != nil)
    end

    record
    |> validates_length(:username, [min: 1])
    |> validates_length(:password, [min: 5], password_validation_condition)
    |> validates_length(:first_name, [min: 1])
    |> validates_inclusion(:role, [in: ["admin", "member"]])
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


  # Override assign_attributes
  # Merge mandatory params and encrypt password if necessary
  def assign_attributes(record, params) do
    super(record, params)
    |> apply(:config_type, ["user"])
    |> apply(:encrypt_password, [])
  end

end
