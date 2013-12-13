AppResolvers.domains = (Domain, $q)->
  deferred = $q.defer()
  successCallback = (domains)-> deferred.resolve(domains)
  errorCallback   = (response)-> deferred.reject()
  Domain.query(successCallback, errorCallback)
  deferred.promise