AppResolvers.auth = (Session, SharedData, $q, $route)->
  return true if SharedData.user?

  deferred = $q.defer()
  successCallback = (data)->
    if data.error?
      SharedData.user = null
      deferred.resolve(data)
    else
      SharedData.user = data.user
      deferred.resolve(data)
  errorCallback   = (response)-> deferred.reject()
  Session.get({}, successCallback, errorCallback)
  deferred.promise