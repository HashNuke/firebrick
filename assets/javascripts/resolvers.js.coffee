AppResolvers = {}

AppResolvers.userSession = ($location, $q, SharedData) ->
  return true if SharedData.user
  $location.path("/login")


# TODO change this to domains. To fetch multiple domains
AppResolvers.domain = (Domain, $q, $route)->
  return {} if !$route.current.params.domain_id

  deferred = $q.defer()
  successCallback = (domain)-> deferred.resolve domain
  errorCallback   = (errorData)-> deferred.reject()

  requestParams = { id: $route.current.params.domain_id }

  Domain.get(requestParams, successCallback, errorCallback)
  deferred.promise


AppResolvers.auth = (Session, $q, $route)->

  deferred = $q.defer()
  successCallback = (session)->  deferred.resolve(session)
  errorCallback   = (response)-> deferred.reject()

  Session.get({}, successCallback, errorCallback)
  deferred.promise


# TODO need another resolver to fetch multiple users
AppResolvers.user = (User, $q, $route)->
  return {role: "member"} if !$route.current.params.user_id

  deferred = $q.defer()
  successCallback = (user)-> deferred.resolve user
  errorCallback   = (errorData)-> deferred.reject()

  requestParams = { id: $route.current.params.user_id }

  User.get(requestParams, successCallback, errorCallback)
  deferred.promise