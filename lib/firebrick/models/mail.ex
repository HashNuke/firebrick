defmodule Mail do
  use Ecto.Model

  schema "mails" do
    field :from
    field :reply_to
    field :to,  {:array, :string}
    field :cc,  {:array, :string}
    field :bcc, {:array, :string}

    field :message_id
    field :references, {:array, :string}

    field :subject
    field :html_body
    field :plain_body

    field :raw_mail
    field :created_at, :datetime

    belongs_to :user, User
    has_many :mails, Mail
  end
end
