window.App = Em.Application.create({LOG_TRANSITIONS: true})
App.ApplicationSerializer = DS.ActiveModelSerializer.extend({})
App.ApplicationAdapter = DS.RESTAdapter.reopen({namespace: "api"})

App.ApplicationView = Em.View.extend
  classNames: ["container"]

App.AuthenticatedRoute = Em.Route.extend
  beforeModel: (transition)->
    applicationController = @controllerFor("application")
    if applicationController.get("currentUser")
      return true

    Ember.$.getJSON("/api/sessions").then (response)=>
      if response.user
        user = @store.createRecord('current_user', response.user)
        @controllerFor('application').set('currentUser', user)
      else
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
      mm: "%d min ago",
      h:  "an hr ago",
      hh: "%d hrs ago",
      d:  "a day ago",
      dd: "%d days ago",
      M:  "a month ago",
      MM: "%d months ago",
      y:  "a year ago",
      yy: "%d years ago"
})


Em.Handlebars.helper 'relativeTime', (value, options)->
  time = moment(value)
  difference = moment().unix() - time.unix()
  if difference > 31536000
    time.format("MMM D, YYYY")
  else if difference > 86400
    time.format("MMM D")
  else
    time.fromNow(true)



App.MailPreviewTransform = DS.Transform.extend
  deserialize: (serialized)->
    return serialized

  serialize: (deserialized)->
    return deserialized


App.MailPreviewsTransform = DS.Transform.extend
  deserialize: (serialized)->
    return serialized

  serialize: (deserialized)->
    return deserialized


App.ArrayTransform = DS.Transform.extend
  deserialize: (serialized)->
    return serialized if Em.typeOf(serialized) == "array"
    []

  serialize: (deserialized)->
    return deserialized if Em.typeOf(deserialized) == 'array'
    []


App.Domain = DS.Model.extend
  name: DS.attr("string")


App.User = DS.Model.extend
  username:  DS.attr("string")
  firstName: DS.attr("string")
  lastName:  DS.attr("string")
  role:      DS.attr("string", defaultValue: "member")
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
  userId: DS.attr("string")
  timezone: DS.attr("string")


App.Router.map ()->
  # /login
  @route "login"

  # /domains
  @resource "domains"

  # /compose
  @route "compose", {path: "/compose"}

  # /threads/in/:category
  # /threads/:thread_id
  @resource "threads", ()->
    @route "in", {path: "/in/:category"}
    @route "thread", {path: "/:thread_id"}

  # /users
  # /users/new
  # /users/:user_id
  @resource "users", ()->
    @route "new"
    @resource "user", {path: "/:user_id"}, ->
      @route "edit"


App.ApplicationController = Em.Controller.extend
  currentUser: false

App.ThreadsInRoute = App.AuthenticatedRoute.extend
  model: (params)->
    category = params.category || "inbox"
    console.log category
    @controllerFor("threads.in").set("title", category)
    @store.find("thread", {category: category})


App.IndexRoute = App.ThreadsInRoute.extend
  needs: ["application"]

App.ThreadsInController = Em.ArrayController.extend
  needs: ["application"]


App.DomainsRoute = App.AuthenticatedRoute.extend
  model: (params)->
    @store.find("domain")


App.DomainItemController = Em.ObjectController.extend
  actions:
    remove: ->
      domain = @get('model')
      domain.deleteRecord()
      successCallback  = =>
        console.log("deleted")
      errorCallback = =>
        console.log("error whatever...")
      domain.save().then(successCallback, errorCallback)


App.DomainsController = Em.ArrayController.extend
  needs: ["application"]
  itemController: "DomainItem"

  actions:
    add: ->
      newDomain = @store.createRecord("domain", {name: @get("newDomainName")})
      successCallback = =>
        console.log("saved")
        @set("newDomainName", "")
      errorCallback = =>
        console.log("error adding domain")
      newDomain.save().then(successCallback, errorCallback)


App.UsersIndexRoute = App.AuthenticatedRoute.extend
  model: (params)->
    @store.find("user")

App.UserItemController = Em.ObjectController.extend
  actions:
    remove: ->
      user = @get("model").deleteRecord()
      successCallback  = =>
        console.log("deleted")
      errorCallback = =>
        console.log("error whatever...")
      user.save().then(successCallback, errorCallback)


App.UsersIndexController = Em.ArrayController.extend
  needs: ["application"]
  itemController: "UserItem"
  title: "Users"

App.UserRoute = App.AuthenticatedRoute.extend
  model: (params)->
    if params.user_id
      @store.find("user", params.user_id)
    else
      @store.createRecord("user")


App.UserEditRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "title", "Edit User"
    controller.set "user", model
    controller.set "domains", @store.find("domain")

  model: ->
    @modelFor("user")


App.UserEditController = Em.Controller.extend
  needs: ["application"]
  validRoles: ["admin", "member"]


App.UsersNewRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "title", "New User"
    controller.set "domains", @store.find("domain")
    controller.set "user", model

  model: ->
    @store.createRecord("user")

  renderTemplate: (controller, model)->
    @render "user/edit"


App.UsersNewController = App.UserEditController.extend
  needs: ["application"]

App.LoginController = Em.Controller.extend
  needs: ["application"]
  username: "admin"
  password: "password"
  actions:
    login: ->
      data = @getProperties('username', 'password')
      Em.$.post("/api/sessions", data).then (response)=>
        if response.error
          console.log "error", response
        else
          user = @store.createRecord('user', response.user)
          @set("controllers.application.currentUser", user)
          @transitionToRoute('threads.in', 'inbox')
