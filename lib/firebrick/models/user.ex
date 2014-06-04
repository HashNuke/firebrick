defmodule User do
  use Ecto.Model

  schema "users" do
    field :first_name
    field :last_name
    field :encrypted_password
    field :active, :boolean

    belongs_to :user_role, UserRole
    has_many :addresses, Address
  end
end
