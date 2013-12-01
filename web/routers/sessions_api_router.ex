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
    {:ok, params} = conn.req_body
    |> JSEX.decode

    {results, count, _} = User.query("config_type:user AND username:#{params["username"]}")

    if count > 0 do
      result = results |> hd
      if User.valid_password?(result, params["password"]) do
        conn = put_session(conn, :user_id, result.id)

        json_response [user: result.public_attributes], conn
      else
        json_response [error: "Please check your login credentials"], conn, 401
      end
    else
      json_response [error: "Maybe you don't have an account?"], conn
    end
  end


  delete "/" do
    json_response [ok: "logged out"], delete_session(conn, :user_id)
  end
end
