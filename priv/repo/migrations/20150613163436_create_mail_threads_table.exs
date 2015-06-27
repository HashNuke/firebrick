defmodule Firebrick.Repo.Migrations.CreateMailThreadsTable do
  use Ecto.Migration

  def change do
    create table(:mail_threads) do
      add :user_id, :integer
      add :subject

      timestamps
    end
  end
end
