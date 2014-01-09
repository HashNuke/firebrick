App.ThreadsInRoute = App.AuthenticatedRoute.extend
  model: (params)->
    category = params.category || "inbox"
    @controllerFor("threads.in").set("title", category)
    @store.find("thread", {category: category})
