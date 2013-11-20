window.AppResolvers = {}

AppResolvers.userSession = ($location, $q, SharedData) ->
  return true if SharedData.user
  $location.path("/login")


AppResolvers.auth = (Session, $q, $route)->
  deferred = $q.defer()
  successCallback = (session)->  deferred.resolve(session)
  errorCallback   = (response)-> deferred.reject()
  Session.get({}, successCallback, errorCallback)
  deferred.promise


AppResolvers.domains = (Domain, $q)->
  deferred = $q.defer()
  successCallback = (domains)-> deferred.resolve(domains)
  errorCallback   = (response)-> deferred.reject()
  Domain.query(successCallback, errorCallback)
  deferred.promise


AppResolvers.users = (User, $q)->
  deferred = $q.defer()
  successCallback = (users)-> deferred.resolve(users)
  errorCallback   = (response)-> deferred.reject()
  User.query(successCallback, errorCallback)
  deferred.promise


AppResolvers.user = (User, $q, $route)->
  return {role: "member"} if !$route.current.params.user_id
  requestParams = { id: $route.current.params.user_id }

  deferred = $q.defer()
  successCallback = (user)-> deferred.resolve user
  errorCallback   = (errorData)-> deferred.reject()

  User.get(requestParams, successCallback, errorCallback)
  deferred.promise
