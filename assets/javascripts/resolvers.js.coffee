window.AppResolvers = {}

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


AppResolvers.domains = (Domain, $q)->
  deferred = $q.defer()
  successCallback = (domains)-> deferred.resolve(domains)
  errorCallback   = (response)-> deferred.reject()
  Domain.query(successCallback, errorCallback)
  deferred.promise


AppResolvers.threads = (Thread, $q, $route)->
  requestParams = { category: $route.current.params.category || "inbox" }

  deferred = $q.defer()
  successCallback = (threads)->
    deferred.resolve(threads)
  errorCallback   = (errorData)->
    deferred.reject()

  Thread.inCategory(requestParams, successCallback, errorCallback)
  deferred.promise


AppResolvers.thread = (Thread, $q, $route)->
  requestParams = { id: $route.current.params.thread_id }

  deferred = $q.defer()
  successCallback = (thread)-> deferred.resolve thread
  errorCallback   = (errorData)-> deferred.reject()

  Thread.get(requestParams, successCallback, errorCallback)
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
