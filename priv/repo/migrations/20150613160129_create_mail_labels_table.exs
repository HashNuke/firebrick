defmodule Firebrick.Repo.Migrations.CreateMailLabelsTable do
  use Ecto.Migration

  def change do
    create table(:mail_labels) do
      add :name, :text
      add :primary, :boolean
      add :label_type, :string
      add :user_id, :integer

      timestamps
    end
  end
end
