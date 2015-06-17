defmodule Firebrick.Mail do
  use Ecto.Model

  schema "mails" do
    field :from, :string
    field :to, {:array, :string}
    field :cc, {:array, :string}
    field :bcc, {:array, :string}
    field :subject, :string
    field :plain_body, :string
    field :html_body, :string

    belongs_to :mail_thread, Firebrick.MailThread

    #TODO has_many_in_array :mail_labels, Firebrick.MailLabel
    # use the mail_label_ids field
  end
end
