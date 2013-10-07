defmodule SessionsRouter do
  use Dynamo.Router


  get "/login" do
    conn = conn.assign(:title, "Login")
    render conn, "index.html"
  end


  get "/logout" do
    conn = conn.assign(:title, "Logout")
    render conn, "index.html"
  end

end
