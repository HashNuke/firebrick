defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params, :body]).assign :layout, "application"
  end

  # It is common to break your Dynamo into many
  # routers, forwarding the requests between them:
  # forward "/posts", to: PostsRouter

  forward "/api/domains", to: DomainsApiRouter
  forward "/api/users", to: UsersApiRouter
  forward "/api/mails", to: MailsApiRouter

  forward "/sessions", to: SessionsRouter


  get "/" do
    conn = conn.assign(:title, "Firebrick Mail")
    render conn, "index.html"
  end


  Enum.map ["/users/*", "/mails/*"], fn(route)->
    get route do
      conn = conn.assign(:title, "Firebrick Mail")
      render conn, "index.html"
    end
  end

end
