window.app = angular.module('Rinket', ['ngRoute', 'ngResource', 'ngSanitize'])

routes = ($routeProvider)->
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


app.config ['$routeProvider', routes]

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
  $scope.shared_data = SharedData

app.controller 'MailsCtrl', ($scope, SharedData)->
  $scope.shared_data = SharedData
  $scope.shared_data.title = "Main"
  console.log $scope.shared_data
  console.log "mails controller"

app.controller 'UsersListCtrl', ($scope, SharedData)->
  $scope.shared_data = SharedData
  $scope.shared_data.title = "Users"
  console.log $scope.shared_data
  console.log "users controller"

app.controller 'UserCtrl', ($scope, SharedData)->
  console.log "manage user controller"
