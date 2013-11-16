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


  def validate(record) do
    # Validate password for new record or for an existing record with a password change
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


  def assign_attrs(record, params) do
    Enum.reduce(params, record, fn({param, value}, updated_record)->
      apply(updated_record, :"#{param}", [value])
    end)
    |> apply(:config_type, ["user"])
    |> apply(:encrypt_password, [])
  end


  def public_attrs(record) do
    lc attr inlist [:id, :username, :first_name, :last_name, :role] do
      { attr, apply(record, :"#{attr}", []) }
    end
  end


  def find(user_id) do
    data = Rinket.Db.get("rinket_config", user_id)
    User.assign_attrs(User[id: user_id], data)
  end


  def saveable_attrs(record) do
    clean_attrs = Enum.reduce [:id, :password], record.attributes, fn(attr, attrs)->
      ListDict.delete(attrs, :"#{attr}")
    end
    Enum.filter(clean_attrs, fn({attr, value})-> value != nil end)
  end


  def save(record) do
    record = record.validate
    if length(record.errors) == 0 do
      id = record.id || :undefined

      case record.id do
        nil ->
          {:ok, Rinket.Db.put("rinket_config", :undefined, record.saveable_attrs) }
        _ ->
          {:ok, Rinket.Db.patch("rinket_config", id, record.saveable_attrs) }
      end
    else
      {:error, record}
    end
  end


  def find_all(options // []) do
    options = [rows: options[:rows] || 50]
    results = Rinket.Db.search("rinket_config", "config_type:user", options)
    lc result inlist results do
      User.assign_attrs(User[], result)
    end
  end
end
