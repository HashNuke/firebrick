defmodule Firebrick.MailThread do
  use Ecto.Model

  schema "mail_threads" do
    field :subject, :text
    belongs_to :mailbox, Firebrick.Mailbox
    has_many :mails, Firebrick.Mail
  end
end
