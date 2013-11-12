defmodule UsersApiRouter do
  use Dynamo.Router


  def json_response(data, conn, status // 200) do
    conn.resp status, :jsx.encode(data)
  end


  get "/" do
    Rinket.Db.search("rinket_config", "config_type:user", [rows: 50])
    |> json_response(conn)
  end


  post "/" do
    user_params = whitelist_params(conn.params, ["first_name", "last_name", "username", "password", "role"])
    errors = validate_user(user_params)

    if ListDict.size(errors) == 0 do
      user_params = ListDict.merge(user_params, [
        "config_type": "user",
        "encrypted_password": hash_password(Dict.get(user_params, "password"))
      ])
        |> ListDict.delete("password")

      key = Rinket.Db.create("rinket_config", user_params)
      json_response [ok: key], conn
    else
      json_response [errors: errors], conn
    end
  end


  get "/:user_id" do
    user_id = conn.params["user_id"]
    attributes = Rinket.Db.get("rinket_config", user_id)
      |> whitelist_params(["first_name", "last_name", "username", "role"])
      |> ListDict.merge([id: user_id])
      |> json_response conn
  end


  post "/:user_id" do
    user_id = conn.params[:user_id]
    user_params = conn.req_body
      |> :jsx.decode
      |> whitelist_params(["first_name", "last_name", "username", "password", "role"])

    user_params = Rinket.Db.get("rinket_config", user_id)
      |> ListDict.merge(user_params)

    errors = validate_user(user_params)

    if ListDict.size(errors) == 0 do
      user_params = ListDict.merge(user_params, [
        "config_type": "user"
      ])

      Rinket.Db.patch("rinket_config", conn.params["user_id"], user_params)
      json_response [ok: user_id], conn
    else
      json_response [errors: errors], conn
    end
  end


  delete "/:user_id" do
    Rinket.Db.delete("rinket_config", conn.params["user_id"])
    json_response([ok: conn.params["user_id"]], conn)
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


  def validate_user(data) do
    errors = []
    if size(Dict.get(data, "username")) == 0 do
      errors = ListDict.merge errors, [username: "must be atleast 1 character"]
    end

    if Dict.get(data, "password") && size(Dict.get(data, "password")) < 5 do
      errors = ListDict.merge errors, [password: "must be atleast 5 characters long"]
    end

    if size(Dict.get(data, "first_name")) < 1 do
      errors = ListDict.merge errors, [password: "must be atleast 1 character long"]
    end

    unless :lists.member(Dict.get(data, "role"), ["admin", "member"]) do
      errors = ListDict.merge errors, [role: "is an unknown role"]
    end

    errors
  end


  defp hash_password(password) do
    {:ok, salt} = :bcrypt.gen_salt()
    {:ok, hashed_password} = :bcrypt.hashpw(password, salt)
    "#{hashed_password}"
  end
end
