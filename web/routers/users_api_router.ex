defmodule UsersApiRouter do
  use Dynamo.Router
  import Rinket.RouterUtils

  def json_response(data, conn, status // 200) do
    conn.resp status, JSEX.encode(data)
  end


  defp whitelist_params(params, allowed) do
    whitelist_params(params, allowed, [])
  end

  defp whitelist_params(params, [], collected) do
    collected
  end

  defp whitelist_params(params, allowed, collected) do
    [field | rest] = allowed
    if Dict.has_key?(params, field) do
      collected = ListDict.merge collected, [{ field, Dict.get(params, field) }]
    end
    whitelist_params(params, rest, collected)
  end


  get "/" do
    users = lc user inlist User.search("config_type:user", [rows: 50]) do
      user.public_attributes
    end
    json_response(users, conn)
  end


  post "/" do
    user_params = whitelist_params(conn.params, ["first_name", "last_name", "username", "password", "role"])
    user = User.assign_attributes(User[], user_params)
    case user.save do
      {:ok, key} ->
        json_response [ok: key], conn
      {:error, user} ->
        json_response [errors: user.errors], conn
    end
  end


  get "/:user_id" do
    user_id = conn.params["user_id"]
    User.find(user_id).public_attributes
    |> json_response conn
  end


  post "/:user_id" do
    user_id = conn.params[:user_id]
    user_params = conn.req_body
      |> :jsx.decode
      |> whitelist_params(["first_name", "last_name", "username", "password", "role"])

    user = User.find(user_id)
    |> User.assign_attributes(user_params)

    case user.save() do
      {:ok, key} ->
        json_response [ok: user_id], conn
      {:errors, user} ->
        json_response [errors: user.errors], conn
    end
  end


  delete "/:user_id" do
    user_id = conn.params["user_id"]
    User.destroy user_id
    json_response([ok: user_id], conn)
  end

end
