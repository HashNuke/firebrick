App.IndexRoute = App.AuthenticatedRoute.extend
  model: (params)->
    category = "inbox"
    @controllerFor("threads.in").set("title", category)
    @store.find("thread", {category: category})
