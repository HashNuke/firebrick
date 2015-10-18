ExUnit.start

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Firebrick.Repo)



defmodule Firebrick.TestHelpers do

  alias Firebrick.Repo
  import Ecto.Query


  def clear_db do
    [
      Firebrick.Contact,
      Firebrick.MailThread,
      Firebrick.Mail,
      Firebrick.MailLabel,
      Firebrick.Domain,
      Firebrick.User
    ]
    |> Enum.map &(Repo.delete_all &1)
  end


  def create(type) do
    create(type, %{})
  end


  def create(:user, opts) do
    attrs = opts

    if opts[:username] do
      attrs = put_in attrs, [:username], Faker.Internet.user_name
    end

    if opts[:password] do
      attrs = put_in attrs, [:password], Faker.Lorem.characters(10)
    end

    %Firebrick.User{}
    |> Map.merge(attrs)
    |> Repo.insert!
  end


  def create(:domain, opts) do
    attrs = opts
    if attrs[:name] do
      attrs = put_in attrs, [:name], Faker.Internet.domain_name
    end

    %Firebrick.Domain{}
    |> Map.merge(attrs)
    |> Repo.insert!
  end


  def create(:mail_label, opts) do
    %Firebrick.MailLabel{}
    |> Map.merge(opts)
    |> Repo.insert!
  end


  def create(:contact, opts) do
    %Firebrick.Contact{}
    |> Map.merge(opts)
    |> Repo.insert!
  end
end
