defmodule Firebrick.Repo.Migrations.CreateMailsTable do
  use Ecto.Migration

  def change do
    create table(:mails) do
      add :mail_thread_id, :integer

      field :from_id, :integer
      field :to_ids, {:array, :integer}
      field :cc_ids, {:array, :integer}
      field :bcc_ids, {:array, :integer}

      add :raw_from, :text
      add :raw_to, {:array, :text}
      add :raw_from, {:array, :text}
      add :raw_bcc, {:array, :text}

      add :subject, :text
      add :plain_body, :text
      add :html_body, :text

      add :unique_mail_id, :string

      timestamps
    end
  end
end
