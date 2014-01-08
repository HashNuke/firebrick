window.App = Ember.Application.create({LOG_TRANSITIONS: true})
App.ApplicationSerializer = DS.ActiveModelSerializer.extend({})
App.ApplicationAdapter = DS.RESTAdapter.reopen({namespace: "api"})


App.AuthenticatedRoute = Ember.Route.extend
  beforeModel: (transition)->
    applicationController = @controllerFor("application")
    if applicationController.get("currentUser")
      return true

    Ember.$.getJSON("/api/sessions").then (response)=>
      if response.user
        user = @store.createRecord('current_user', response.user)
        @controllerFor('application').set('currentUser', user)
      else
        console.log response
        @redirectToLogin(transition)

  # Redirect to the login page and store the current transition so we can
  # run it again after login
  redirectToLogin: (transition)->
    loginController = @controllerFor("login")
    # loginController.set("attemptedTransition", transition)
    @transitionTo("login")

  #TODO not sure why this is here
  actions:
    error: (reason, transition)->
      console.log "ERROR: moving to login", error
      this.redirectToLogin(transition)


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


App.ArrayTransform = DS.Transform.extend
  deserialize: (serialized)->
    return serialized if Ember.typeOf(serialized) == "array"
    []

  serialize: (deserialized)->
    return deserialized if Ember.typeOf(deserialized) == 'array'
    []


App.User = DS.Model.extend
  username:  DS.attr("string")
  firstName: DS.attr("string")
  lastName:  DS.attr("string")
  role:      DS.attr("string")
  domainId:  DS.attr("string")
  primaryAddress: DS.attr("string")


App.CurrentUser = App.User.extend({})


App.Thread = DS.Model.extend
  subject: DS.attr("string")
  createdAtDt: DS.attr("string")
  updatedAtDt: DS.attr("string")
  messageIds: DS.attr("array")
  mailPreviews: DS.attr("mailPreview")
  mailPreview: DS.attr("mailPreview")
  category: DS.attr("string")
  read: DS.attr("boolean")
  user_id: DS.attr("string")
  timezone: DS.attr("string")


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
    @resource "user", {path: "/:user_id"}, ()->
      @route("edit")
  )

  # /domains
  @route("domains")


App.ThreadsRoute = App.AuthenticatedRoute.extend({})
App.IndexRoute = App.AuthenticatedRoute.extend({})

App.UsersIndexRoute = Ember.Route.extend
  model: (params)->
    @store.find("user")


App.ApplicationController = Ember.Controller.extend
  currentUser: false
  pageTitle: null

App.UsersIndexController = Ember.ArrayController.extend({})

App.LoginController = Ember.Controller.extend
  needs: ["application"]
  username: "admin"
  password: "password"
  actions:
    login: ->
      data = @getProperties('username', 'password')
      Ember.$.post("/api/sessions", data).then (response)=>
        if response.error
          console.log "error", response
        else
          user = @store.createRecord('user', response.user)
          @set("controllers.application.currentUser", user)
          @transitionToRoute('threads.in', 'inbox')
