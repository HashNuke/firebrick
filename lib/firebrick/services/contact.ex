defmodule Firebrick.Services.Contact do

  import Ecto.Query
  alias Firebrick.Repo
  alias Firebrick.Contact

  def find_or_create(identity, details_list) do
    find_or_create identity, details_list, []
  end


  def find_or_create(_identity, [], contacts) do
    contacts
  end


  def find_or_create(identity, [%{name: name, email: email} | rest], contacts) do
    contact = case Repo.query(from ct in Contact, where: ct.email == ^email) do
      nil ->
        %Contact{name: name, email: email, user_id: identity.user.id}
        |> Repo.insert
      contact_record ->
        contact_record
    end
    find_or_create identity, rest, [contact | contacts]
  end

end
