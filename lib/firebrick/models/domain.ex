defmodule Domain do
  use Ecto.Model

  schema "domains" do
    field :name

    has_many :addresses, Address
  end
end
