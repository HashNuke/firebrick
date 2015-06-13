defmodule Firebrick.Repo.Migrations.CreateMailsTable do
  use Ecto.Migration

  def change do
    create table(:mails) do
      add :mail_thread_id, :integer
      add :from, :text
      add :to, :text
      add :cc, {:array, :text}
      add :bcc, {:array, :text}
      add :subject, :text
      add :plain_body, :text
      add :html_body, :text
      add :mail_label_ids, {:array, :integer}

      timestamps
    end
  end
end
