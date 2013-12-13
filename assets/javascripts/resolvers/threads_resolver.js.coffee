AppResolvers.threads = (Thread, $q, $route)->
  requestParams = { category: $route.current.params.category || "inbox" }

  deferred = $q.defer()
  successCallback = (threads)->
    deferred.resolve(threads)
  errorCallback   = (errorData)->
    deferred.reject()

  Thread.inCategory(requestParams, successCallback, errorCallback)
  deferred.promise