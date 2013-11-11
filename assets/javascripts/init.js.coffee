window.app = angular.module('Rinket', ['ngRoute', 'ngResource', 'ngSanitize'])

routes = ($routeProvider)->
  $routeProvider.when('/',
      templateUrl: '/static/partials/hello.html',
      controller: "MailsCtrl"
    ).when('/mails/:category',
      templateUrl: '/static/partials/mails.html',
      controller: 'MailsCtrl'
    ).when('/users/:user_id',
      templateUrl: '/static/partials/users.html'
      controller: 'UsersCtrl'
    ).otherwise(redirectTo: '/not_found')


app.config ['$routeProvider', routes]

app.controller 'MailsCtrl', ($scope)->
  console.log "mail controller"
