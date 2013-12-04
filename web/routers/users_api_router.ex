defmodule UsersApiRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils

  prepare do
    authorize_user!(conn, ["admin"])
  end


  get "/" do
    {users, count, _} = User.query("type:user")
    lc user inlist users do
      user.public_attributes
    end
    |> json_response(conn)
  end


  post "/" do
    user_id = conn.params[:user_id]
    {:ok, params} = conn.req_body
    |> JSEX.decode

    user_params = whitelist_params(params, ["domain_id", "first_name", "last_name", "username", "password", "role"])
    user = User.assign_attributes(User[], user_params)
    case user.save do
      {:ok, key} ->
        json_response [ok: key], conn
      {:error, user} ->
        json_response [errors: user.errors], conn, 422
    end
  end


  get "/:user_id" do
    user_id = conn.params["user_id"]
    User.find(user_id).public_attributes
    |> json_response conn
  end


  post "/:user_id" do
    user_id = conn.params[:user_id]
    {:ok, params} = conn.req_body
    |> JSEX.decode

    user_params = whitelist_params(params, ["domain_id", "first_name", "last_name", "username", "password", "role"])

    user = User.find(user_id)
    |> User.assign_attributes(user_params)

    case user.save() do
      {:ok, key} ->
        json_response [ok: user_id], conn
      {:error, user} ->
        json_response [errors: user.errors], conn, 422
    end
  end


  delete "/:user_id" do
    user_id = conn.params["user_id"]
    User.destroy user_id
    json_response([ok: user_id], conn)
  end

end
