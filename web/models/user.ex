defmodule Firebrick.User do
  use Ecto.Model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    belongs_to :role, Firebrick.Role

    timestamps
  end
end
