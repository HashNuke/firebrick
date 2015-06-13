defmodule Firebrick.Repo.Migrations.CreateMailLabelsTable do
  use Ecto.Migration

  def change do
    create table(:mail_labels) do
      add :name, :text
      add :primary, :boolean
      timestamps
    end
  end
end
