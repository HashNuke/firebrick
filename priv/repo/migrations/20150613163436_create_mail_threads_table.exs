defmodule Firebrick.Repo.Migrations.CreateMailThreadsTable do
  use Ecto.Migration

  def change do
    create table(:mail_threads) do
      add :user_id, :integer
      add :subject, :string
      add :participant_ids, {:array, :integer}
      add :mail_label_ids, {:array, :integer}

      timestamps
    end
  end
end
