defmodule Firebrick.Contact do
  use Firebrick.Web, :model

  schema "contacts" do
    field :name, :string
    field :email, :string
    field :gravatar_hash, :string

    belongs_to :user, Firebrick.User

    timestamps
  end

  @required_fields ~w(name email gravatar_hash user_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
