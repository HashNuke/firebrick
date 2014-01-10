App.UsersNewRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "domains", @store.find("domain")
    controller.set "user", model

  model: ->
    @store.createRecord("user")
