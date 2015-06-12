defmodule Firebrick.Repo.Migrations.CreateMailboxesTable do
  use Ecto.Migration

  def change do
    create table(:mailboxes) do
      add :email, :text
      add :domain_id, :integer
      add :mailbox_type, :text
      add :alias_of_id, :integer
    end
  end
end
