App.UserEditRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "user", model._data
    controller.set "domains", @store.find("domain")

  model: ->
    @modelFor("user")
