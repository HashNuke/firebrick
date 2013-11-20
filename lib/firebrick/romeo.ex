defmodule Firebrick.Auth do

  import Dynamo.HTTP.Session

  def authenticate_user!(conn) do
    user_id = get_session(conn, :user_id)
    if user_id do
      user = User.find(user_id)
      conn.assign(:current_user, user)
    else
      halt! conn.status(401)
    end
  end


  def authorize_user!(conn, allowed_roles) do
    user_id = get_session(conn, :user_id)

    if user_id do
      user = User.find(user_id)
      if :lists.member user.role, allowed_roles do
        conn = conn.assign(:current_user, user)
      else
        halt! conn.status(401)
      end
    else
      halt! conn.status(401)
    end
  end
end
