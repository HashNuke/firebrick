defmodule Firebrick.MailLabel do
  use Ecto.Model

  schema("mail_labels") do
    field :name, :string
    field :primary, :boolean
    field :label_type, :string

    belongs_to :user, Firebrick.User

    timestamps
  end
end
