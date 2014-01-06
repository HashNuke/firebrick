defmodule SessionsApiRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils


  get "/" do
    user_id = get_session conn, :user_id
    if user_id do
      json_response [user: User.find(user_id).public_attributes], conn
    else
      json_response [error: "no session"], conn
    end
  end


  post "/" do
    params = conn.params
    login(conn, params["username"], params["password"])
  end


  delete "/" do
    json_response [ok: "logged out"], delete_session(conn, :user_id)
  end


  defp login(conn, username, password) when username == nil or password == nil do
    json_response [error: "Please check your login credentials."], conn, 401
  end

  defp login(conn, username, password) do
    {results, count, _} = User.query("type:user AND username:#{username}")

    case count > 0 do
      true ->
        result = results |> hd
        if User.valid_password?(result, password) do
          conn = put_session(conn, :user_id, result.id)
          json_response [user: result.public_attributes], conn
        else
          json_response [error: "Please check your login credentials."], conn, 401
        end
      false ->
        json_response [error: "Maybe you don't have an account?"], conn, 401
    end
  end

end
