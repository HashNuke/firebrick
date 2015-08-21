defmodule Firebrick.Services.Contact do

  import Ecto.Query
  alias Firebrick.Repo
  alias Firebrick.Contact


  def find_or_create(user, details) when is_map(details) do
    find_or_create user, [details], []
  end


  def find_or_create(user, details_list) when is_list(details_list) do
    find_or_create user, details_list, []
  end


  def find_or_create(_user, [], contacts) do
    contacts
  end


  def find_or_create(user, [%{name: name, email: email} | rest], contacts) do
    contact = case Repo.all(from c in Contact, where: c.email == ^email) do
      [] ->
        %Contact{name: name, email: email, user_id: user.id}
        |> Repo.insert
      contact_record ->
        contact_record
    end
    find_or_create user, rest, [contact | contacts]
  end

end
