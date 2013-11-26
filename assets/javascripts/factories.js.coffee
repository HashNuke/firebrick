app.factory 'SharedData', ()-> {notification: 0, title: ""}


app.factory 'Thread', ($resource)->
  customActions =
    update: {method: "POST"}
    inCategory: {method: "GET", isArray: true, params: {collectionRoute: "in"}}

  $resource(
    "/api/threads/:collectionRoute:id/:memberRoute:category",
    { id: "@id", category: "@category", collectionRoute: '@collectionRoute', memberRoute: '@memberRoute'},
    customActions
  )


app.factory 'User', ($resource)->
  customActions = {update: {method: "POST"}}

  $resource(
    "/api/users/:collectionRoute:id/:memberRoute",
    { id: "@id", collectionRoute: '@collectionRoute', memberRoute: '@memberRoute'},
    customActions
  )

app.factory 'Domain', ($resource)->
  $resource(
    "/api/domains/:collectionRoute:id/:memberRoute",
    { id: "@id", collectionRoute: '@collectionRoute', memberRoute: '@memberRoute'}
  )

app.factory 'Session', ($resource)->
  $resource("/api/sessions")
