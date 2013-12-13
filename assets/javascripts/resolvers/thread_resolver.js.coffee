AppResolvers.thread = (Thread, $q, $route)->
  requestParams = { id: $route.current.params.thread_id }

  deferred = $q.defer()
  successCallback = (thread)-> deferred.resolve thread
  errorCallback   = (errorData)-> deferred.reject()

  Thread.get(requestParams, successCallback, errorCallback)
  deferred.promise