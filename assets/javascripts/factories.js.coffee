app.factory 'SharedData', ()-> {notification: 0, title: ""}

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