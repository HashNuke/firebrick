defmodule Firebrick.UserRole do
  use Ecto.Model

  schema "user_roles" do
    field :name, :string
    has_many :users, Firebrick.User

    timestamps
  end
end
