App.UserEditRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "title", "Edit User"
    controller.set "user", model
    controller.set "domains", @store.find("domain")

  model: ->
    @modelFor("user")
