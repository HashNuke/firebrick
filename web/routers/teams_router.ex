defmodule TeamsRouter do
  use Dynamo.Router

  prepare do
    conn.assign :layout, "manage.html"
  end

  get "/" do
    conn = conn.assign(:title, "Login")
    render conn, "index.html"
  end


  post "/" do
    #TODO
  end


  get "/new" do
    conn = conn.assign(:title, "Logout")
    render conn, "index.html"
  end


  get "/:team_id/edit" do
    #TODO
  end


  put "/:team_id" do
    #TODO
  end


  delete "/:team_id" do
    #TODO
  end
end
