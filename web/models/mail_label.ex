defmodule Firebrick.MailLabel do
  use Ecto.Model

  schema(:mail_labels) do
    field :name, :text
    field :primary, :boolean

    timestamps
  end
end
