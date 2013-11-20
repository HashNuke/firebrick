config = ($routeProvider, $locationProvider)->
  $locationProvider.html5Mode(true)

  $routeProvider.when('/',
      templateUrl: '/static/partials/hello.html'
      controller: "MailsCtrl"
      resolve:
        userSession: AppResolvers.userSession
    ).when('/login',
      templateUrl: '/static/partials/login.html'
      controller: 'SessionCtrl'
      resolve:
        auth: AppResolvers.auth
    ).when('/labels/:label',
      templateUrl: '/static/partials/mails.html',
      controller: 'MailsCtrl'
    ).when('/domains',
      templateUrl: '/static/partials/domains.html'
      controller: 'DomainsCtrl'
      resolve:
        userSession: AppResolvers.userSession
    ).when('/users',
      templateUrl: '/static/partials/users/list.html'
      controller: 'UsersListCtrl'
      resolve:
        userSession: AppResolvers.userSession
    ).when('/users/new',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
      resolve:
        userSession: AppResolvers.userSession
        user: AppResolvers.user
    ).when('/users/:user_id/:edit',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
      resolve:
        userSession: AppResolvers.userSession
        user: AppResolvers.user
    ).otherwise(redirectTo: '/not_found')


window.app = angular
  .module('Firebrick', ['ngRoute', 'ngResource', 'ngSanitize'])
  .config ['$routeProvider', '$locationProvider', config]
