defmodule Firebrick.Services.Identity do

  import Ecto.Query
  import Ecto.Model

  alias Firebrick.Repo
  alias Firebrick.Domain
  alias Firebrick.User
  alias Firebrick.Identity


  def find_by_address(address) do
    [username, domain_name] = String.downcase(address) |> String.split("@")

    %Firebrick.Identity{}
    |> find_domain_for_identity(domain_name)
    |> find_user_for_identity(username)
  end


  def find_domain_for_identity(identity, name) do
    query = from d in Domain, where: d.name == ^name, select: d
    domain = Repo.query(query)
    %{identity | domain: domain}
  end


  #TODO handle case where identity has empty domain
  def find_user_for_identity(identity, username) do
    identity
  end


  def find_user_for_identity(identity, username) do
    query = from u in assoc(identity.domain, :users), where: u.username == ^username
    user = Repo.query(query)
    %{identity | user: user}
  end
end
