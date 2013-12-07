app.filter "relativeTime", ->
  (text)-> moment(text).fromNow(true)
