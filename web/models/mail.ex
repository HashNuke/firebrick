defmodule Firebrick.Mail do
  use Ecto.Model

  schema "mails" do
    field :from, :text
    field :to, {:array, :text}
    field :cc, {:array, :text}
    field :bcc, {:array, :text}
    field :subject, :text
    field :plain_body, :text
    field :html_body, :text

    belongs_to :mail_thread, Firebrick.MailThread

    #TODO has_many_in_array :mail_labels, Firebrick.MailLabel
    # use the mail_label_ids field
  end
end
