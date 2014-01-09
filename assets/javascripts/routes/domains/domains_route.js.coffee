App.DomainsRoute = App.AuthenticatedRoute.extend
  model: (params)->
    @store.find("domain")
