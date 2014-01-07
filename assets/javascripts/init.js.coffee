window.App = Ember.Application.create()
App.ApplicationSerializer = DS.ActiveModelSerializer.extend({});
App.ApplicationAdapter = DS.RESTAdapter.reopen({namespace: "api"})

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


App.User = DS.Model.extend({
  username: DS.attr('string'),
  primaryAddress: DS.attr('string'),
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  role: DS.attr('string'),
  domainId: DS.attr('string')
});

# DS.RESTAdapter.map('App.User', {
#   firstName: { key: 'first_name' },
#   lastName: { key: 'last_name' },
#   domainId: { key: 'domain_id' },
#   primaryAddress: { key: 'primary_address' }
# });


App.Router.map ()->
  # /login
  @route("login")

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


App.ApplicationController = Ember.Controller.extend
  currentUser: false


App.LoginController = Ember.Controller.extend
  needs: ["application"]
  actions:
    login: ->
      data = @getProperties('username', 'password')
      console.log @get("controllers.application.currentUser")
      Ember.$.post("/api/sessions", data).then (response)=>
        if response.error
          console.log "error", response
        else
          user = JSON.parse(response).user
          @set("controllers.application.currentUser", @store.createRecord('user', user))
          console.log @get("controllers.application.currentUser")
          @transitionToRoute('threads.in', 'inbox')
