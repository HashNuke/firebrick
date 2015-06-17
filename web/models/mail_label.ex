defmodule Firebrick.MailLabel do
  use Ecto.Model

  schema("mail_labels") do
    field :name, :string
    field :primary, :boolean

    timestamps
  end
end
