defmodule Firebrick.Role do
  use Ecto.Model

  schema "roles" do
    field :name, :text
    has_many :users, Firebrick.User

    timestamps
  end
end
