window.App = Em.Application.create({LOG_TRANSITIONS: true})

App.ApplicationSerializer = DS.ActiveModelSerializer.extend({})
App.ApplicationAdapter    = DS.RESTAdapter.reopen({namespace: "api"})
App.ApplicationView       = Em.View.extend(classNames: ["container"])


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
