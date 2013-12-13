AppResolvers.user = (User, $q, $route)->
  return {role: "member"} if !$route.current.params.user_id
  requestParams = { id: $route.current.params.user_id }

  deferred = $q.defer()
  successCallback = (user)-> deferred.resolve user
  errorCallback   = (errorData)-> deferred.reject()

  User.get(requestParams, successCallback, errorCallback)
  deferred.promise