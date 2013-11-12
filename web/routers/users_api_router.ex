defmodule UsersApiRouter do
  use Dynamo.Router


  def json_response(conn, data) do
    conn.resp 200, :jsx.encode(data)
  end


  get "/" do
    users = Rinket.Db.search("rinket_config", "config_type:user", [rows: 50])
    json_response(conn, users)
  end


  post "/" do
    user_params = whitelist_params(["first_name", "last_name", "username", "password", "role"], conn.params)
    errors = validate_user(user_params)

    if ListDict.size(errors) == 0 do
      user_params = ListDict.merge(user_params, [
        "config_type": "user",
        "password": hash_password(Dict.get(user_params, "password"))
      ])

      key = Rinket.Db.create("rinket_config", user_params)
      json_response conn, [ok: key]
    else
      json_response conn, [errors: errors]
    end
  end


  get "/:user_id" do
    #TODO get a particular user id
  end


  put "/:user_id" do
    #TODO update user
  end


  delete "/:user_id" do
    Rinket.Db.delete("rinket_config", conn.params["user_id"])
    json_response(conn, [ok: conn.params["user_id"]])
  end


  defp whitelist_params(allowed, params) do
    whitelist_params(allowed, params, [])
  end

  defp whitelist_params([], params, collected) do
    collected
  end

  defp whitelist_params(allowed, params, collected) do
    [field | rest] = allowed
    if Dict.has_key?(params, field) do
      collected = ListDict.merge collected, [{ field, Dict.get(params, field) }]
    end
    whitelist_params(rest, params, collected)
  end


  defp validate_user(data) do
    errors = []
    if size(Dict.get(data, "username")) == 0 do
      errors = ListDict.merge errors, [username: "must be atleast 1 character"]
    end

    if size(Dict.get(data, "password")) < 5 do
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
