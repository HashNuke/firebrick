app.filter "relativeTime", ->
  (text)-> moment.unix(text).fromNow(true)
