defmodule Firebrick.Role do
  use Ecto.Model

  schema "roles" do
    field :name, :string
    has_many :users, Firebrick.User

    timestamps
  end
end
