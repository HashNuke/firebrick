App.UsersNewRoute = App.AuthenticatedRoute.extend
  setupController: (controller, model)->
    controller.set "title", "New User"
    controller.set "domains", @store.find("domain")
    controller.set "user", model

  model: ->
    @store.createRecord("user")

  renderTemplate: (controller, model)->
    @render "user/edit"
