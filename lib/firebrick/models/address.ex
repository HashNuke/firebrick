defmodule Address do
  use Ecto.Model

  schema "addresses" do
    field :full_address
    field :primary, :boolean

    belongs_to :user, User
    belongs_to :domain, Domain
  end
end
