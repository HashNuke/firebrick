moment.lang('en', {
  relativeTime :
      future: "in %s",
      past:   "%s",
      s:  "just now",
      m:  "a min ago",
      mm: "%d minutes ago",
      h:  "an hr ago",
      hh: "%d hrs ago",
      d:  "a day ago",
      dd: "%d days ago",
      M:  "a month ago",
      MM: "%d months ago",
      y:  "a year ago",
      yy: "%d years ago"
})


Ember.Handlebars.helper 'relativeTime', (value, options)->
  time = moment(value)
  difference = moment().unix() - time.unix()
  if difference > 31536000
    time.format("MMM D, YYYY")
  else if difference > 86400
    time.format("MMM D")
  else
    time.fromNow(true)



App.Router.map ()->
  # /login
  @route("login", {path: "/login"})

  # /threads/in/:category
  # /threads/:thread_id
  @resource("threads", ()->
    @route("in", {path: "/in/:category"})
    @route("thread", {path: "/:thread_id"})
  )

  # /compose
  @route("compose", {path: "/compose"})

  # /users
  # /users/new
  # /users/:user_id
  @resource("users", ()->
    @route("new");
    @resource("user", {path: "/:user_id"}, ()-> @route("edit"))
  )

  # /domains
  @route("domains")

