defmodule Firebrick.User do
  use Ecto.Model

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    belongs_to :user_role, Firebrick.UserRole
    belongs_to :domain, Firebrick.Domain
    has_many :contacts, Firebrick.Contact

    timestamps
  end


  before_insert :ensure_encrypted_password


  def changeset(model, params \\ :empty) do
    required_fields = ~w(username encrypted_password domain_id role_id)

    if params[:password] do
      required_fields = [:password | required_fields]
    end

    changeset = cast(model, params, required_fields)
    |> validate_length(:username, min: 1)

    if params[:password] do
      validate_length(changeset, :password, min: 6)
    end
  end


  def valid_password?(model, password) do
    Comeonin.Bcrypt.checkpw password, model.encrypted_password
  end


  def ensure_encrypted_password(changeset) do
    new_changeset = changeset
    password = get_field new_changeset, :password

    if password do
      hashed_password = Comeonin.Bcrypt.hashpwsalt(password)
      new_changeset = put_change changeset, :encrypted_password, hashed_password
    end

    new_changeset
  end

end
