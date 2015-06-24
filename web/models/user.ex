defmodule Firebrick.User do
  use Ecto.Model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    belongs_to :role, Firebrick.Role

    timestamps
  end


  def valid_password?(model, password) do
    salt = String.slice(model.encrypted_password, 0, 29)
    {:ok, hashed_password} = :bcrypt.hashpw(password, salt)
    "#{hashed_password}" == model.encrypted_password
  end


  def encrypt_password(model) do
    {:ok, salt} = :bcrypt.gen_salt()
    {:ok, hashed_password} = :bcrypt.hashpw(model.password, salt)
    model.encrypted_password(hashed_password)
  end

end
