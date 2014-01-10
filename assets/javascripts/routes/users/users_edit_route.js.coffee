App.UserEditRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "user", model
    controller.set "domains", @store.find("domain")

  model: ->
    @modelFor("user")
