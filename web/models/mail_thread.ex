defmodule Firebrick.MailThread do
  use Ecto.Model

  schema "mail_threads" do
    field :subject, :string
    field :mail_label_ids, {:array, :integer}
    field :participant_ids, {:array, :integer}

    belongs_to :user, Firebrick.User
    has_many :mails, Firebrick.Mail
  end
end
