defmodule Firebrick.Membership do
  use Ecto.Model

  schema "memberships" do
    belongs_to :user, Firebrick.User
    belongs_to :mailbox, Firebrick.Mailbox

    timestamps
  end
end
