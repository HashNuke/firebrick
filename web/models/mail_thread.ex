defmodule Firebrick.MailThread do
  use Ecto.Model

  schema "mail_threads" do
    field :subject, :string
    belongs_to :user, Firebrick.User
    has_many :mails, Firebrick.Mail
  end
end
