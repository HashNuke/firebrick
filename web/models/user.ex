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
    |> validates_length(:password, [min: 5], password_validation_condition)
    |> validates_length(:first_name, [min: 1])
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


  def public_attributes(record) do
    lc attr inlist [:username, :first_name, :last_name, :role] do
      { attr, apply(record, attr, []) }
    end
  end


  def find(user_id) do
    data = Rinket.Db.get("rinket_config", user_id)
    User[].update(data).id(user_id)
  end
  

  def find_all(options // []) do
    options = [rows: options[:rows] || 50]
    Rinket.Db.search("rinket_config", "config_type:user", options)
  end
end
