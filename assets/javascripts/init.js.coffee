window.app = angular.module('Rinket', ['ngRoute', 'ngResource', 'ngSanitize'])
app.resolvers = {}

app.factory 'SharedData', ()-> {notification: 0, title: ""}

app.factory 'User', ($resource)->
  customActions = {update: {method: "POST"}}

  $resource(
    "/api/users/:collectionRoute:id/:memberRoute",
    { id: "@id", collectionRoute: '@collectionRoute', memberRoute: '@memberRoute'},
    customActions
  )


app.resolvers.user = (User, $q, $route)->
  return {role: "member"} if !$route.current.params.user_id

  deferred = $q.defer()
  successCallback = (user)-> deferred.resolve user
  errorCallback   = (errorData)-> deferred.reject()

  requestParams = { id: $route.current.params.user_id }

  User.get(requestParams, successCallback, errorCallback)
  deferred.promise


config = ($routeProvider, $locationProvider)->
  $locationProvider.html5Mode(true)
  $routeProvider.when('/',
      templateUrl: '/static/partials/hello.html',
      controller: "MailsCtrl"
    ).when('/mails/:category',
      templateUrl: '/static/partials/mails.html',
      controller: 'MailsCtrl'
    ).when('/users',
      templateUrl: '/static/partials/users/list.html'
      controller: 'UsersListCtrl'
    ).when('/users/new',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
      resolve:
        user: app.resolvers.user
    ).when('/users/:user_id/:edit',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
      resolve:
        user: app.resolvers.user
    ).otherwise(redirectTo: '/not_found')


app.config ['$routeProvider', '$locationProvider', config]


app.controller 'RootCtrl', ($scope, SharedData)->
  $scope.sharedData = SharedData

app.controller 'MailsCtrl', ($scope, SharedData)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Main"
  console.log $scope.sharedData
  console.log "mails controller"


app.controller 'UsersListCtrl', ($scope, SharedData, User)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Users"

  $scope.removeUser = (index)->
    successCallback = -> $scope.users.splice(index, 1)
    errorCallback = ->
      #TODO handle errors
    $scope.users[index].$delete(successCallback, errorCallback)

  successCallback = (data)-> $scope.users = data
  errorCallback   = ()-> console.log("error")
  User.query(successCallback, errorCallback)


app.controller 'UserCtrl', ($scope, $route, $location, SharedData, User, user)->
  $scope.sharedData = SharedData

  if !$route.current.params.user_id
    $scope.sharedData.title = "New user"
  else
    $scope.sharedData.title = "Edit user"

  $scope.validRoles = ['admin', 'member']

  $scope.user = user
  $scope.saveUser = ->
    console.log "save user"
    successCallback = (data) ->
      # $location.path("/users")

    errorCallback = (response) =>
      console.log "errors"
      #TODO hamdle errors

    if !$scope.user.id
      console.log User.save($scope.user, successCallback, errorCallback)
    else
      console.log "I in else"
      user = $scope.user
      user.$update(successCallback, errorCallback)

  console.log $scope.user.id
  console.log "manage user controller"
