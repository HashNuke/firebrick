defmodule Firebrick.User do
  use Ecto.Model

  schema "users" do
    field :emal, :text
    field :encrypted_password, :text
    belongs_to :role, Firebrick.Role

    timestamps
  end
end
