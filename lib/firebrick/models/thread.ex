defmodule Thread do
  use Ecto.Model

  schema "threads" do
    field :subject
    field :participants, {:array, :string}
    field :mail_count, :integer
    field :thread_message_id # store message_id of the first mail in thread
    field :updated_at, :datetime

    belongs_to :user, User
    has_many :mails, Mail
  end
end
