defmodule Firebrick.Services.ContactTest do
  use ExUnit.Case

  import Firebrick.TestHelpers
  import Ecto.Query

  alias Firebrick.Repo
  alias Firebrick.Contact

  setup do
    clear_db
    :ok
  end


  def contacts_count(user) do
    Repo.one(from c in Contact, where: c.user_id == ^user.id, select: count(c.id))
  end


  def subject do
    Firebrick.Services.Contact
  end


  def details_list do
    [
      %{name: "Foo", email: "foo@example.com"},
      %{name: "Bar", email: "bar@example.com"},
      %{name: "Baz", email: "baz@example.com"}
    ]
  end


  test "create contacts for user if details are provided" do
    user = create(:user)
    assert contacts_count(user) == 0

    subject.find_or_create(user, details_list)
    assert contacts_count(user) == 3
  end


  test "create contacts for user only if contacts don't exist" do
    user = create(:user)

    {:ok, _contact} = %Contact{user_id: user.id}
      |> Map.merge(hd details_list)
      |> Repo.insert

    assert contacts_count(user) == 1

    subject.find_or_create(user, details_list)
    assert contacts_count(user) == 3
  end

end
