defmodule ApplicationRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :session, :headers, :params, :body]).assign :layout, "application"
  end


  # It is common to break your Dynamo into many
  # routers, forwarding the requests between them:
  # forward "/posts", to: PostsRouter

  forward "/sessions", to: SessionsApiRouter
  forward "/domains",  to: DomainsApiRouter
  forward "/users",    to: UsersApiRouter
  forward "/threads",  to: ThreadsApiRouter
  forward "/mails",    to: MailsApiRouter


  @prepare :authenticate_user!
  get "/" do
    conn = conn.assign(:title, "Firebrick Mail")
    render conn, "index.html"
  end

end
