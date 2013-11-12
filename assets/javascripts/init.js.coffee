window.app = angular.module('Rinket', ['ngRoute', 'ngResource', 'ngSanitize'])

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
    ).when('/users/:user_id',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
    ).otherwise(redirectTo: '/not_found')


app.config ['$routeProvider', '$locationProvider', config]

app.factory 'SharedData', ()->
  {notification: 0, title: "Inbox"}

app.factory 'User', ($resource)->
  customActions =
    update:  {method: "POST"}

  $resource(
    "/api/users/:collectionRoute:id/:memberRoute",
    { id: "@id", collectionRoute: '@collectionRoute', memberRoute: '@memberRoute'},
    customActions
  )


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
    successCallback = ->
      $scope.users.splice(index, 1)

    errorCallback = ->
      #TODO handle errors

    $scope.users[index].$delete(successCallback, errorCallback)


  successCallback = (data)->
    $scope.users = data

  errorCallback   = ()-> console.log("error")
  User.query(successCallback, errorCallback)
  console.log "users controller"

app.controller 'UserCtrl', ($scope, SharedData)->
  console.log "manage user controller"
