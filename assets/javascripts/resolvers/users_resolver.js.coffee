AppResolvers.users = (User, $q)->
  deferred = $q.defer()
  successCallback = (users)-> deferred.resolve(users)
  errorCallback   = (response)-> deferred.reject()
  User.query(successCallback, errorCallback)
  deferred.promise