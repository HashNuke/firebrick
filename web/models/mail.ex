defmodule Firebrick.Mail do
  use Ecto.Model

  schema "mails" do
    belongs_to :contact, Firebrick.Contact, foreign_key: :from_id
    field :to_ids, {:array, :integer}
    field :cc_ids, {:array, :integer}
    field :bcc_ids, {:array, :integer}

    field :raw_from, :string
    field :raw_to, {:array, :string}
    field :raw_cc, {:array, :string}
    field :raw_bcc, {:array, :string}

    field :subject, :string
    field :plain_body, :string
    field :html_body, :string
    field :unique_mail_id, :string

    belongs_to :mail_thread, Firebrick.MailThread

    #TODO has_many_in_array :mail_labels, Firebrick.MailLabel
    # use the mail_label_ids field
  end
end
