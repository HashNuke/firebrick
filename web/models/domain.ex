defmodule Firebrick.Domain do
  use Ecto.Model

  schema "domains" do
    field :name, :text
    has_many :mailboxes, Firebrick.Mailbox

    timestamps
  end
end
