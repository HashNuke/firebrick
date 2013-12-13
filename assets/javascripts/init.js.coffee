window.AppResolvers = {}

moment.lang('en', {
  relativeTime :
      future: "in %s",
      past:   "%s ago",
      s:  "just now",
      m:  "a min",
      mm: "%d minutes",
      h:  "an hr",
      hh: "%d hrs",
      d:  "a day",
      dd: "%d days",
      M:  "a month",
      MM: "%d months",
      y:  "a year",
      yy: "%d years"
})

config = ($routeProvider, $locationProvider, $httpProvider)->
  $locationProvider.html5Mode(true)

  unauthorizedInterceptor = ['$rootScope', '$q', '$location', (scope, $q, $location)->
      success = (response)-> response
      error   = (response)->
        console.log "INTERCEPTER", response
        return $q.reject(response) if response.status != 401
        $location.path("/login") if $location.path != "/login"

      return ((promise)-> promise.then(success, error))
    ]
  $httpProvider.responseInterceptors.push(unauthorizedInterceptor)
  $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'


  $routeProvider.when('/',
      templateUrl: '/static/partials/thread_list.html'
      controller: 'ThreadListCtrl'
      resolve:
        threads: AppResolvers.threads
        auth: AppResolvers.auth
    ).when('/compose/new',
      templateUrl: '/static/partials/compose.html'
      controller: 'ComposeCtrl'
    ).when('/threads/in/:category',
      templateUrl: '/static/partials/thread_list.html'
      controller: 'ThreadListCtrl'
      resolve:
        threads: AppResolvers.threads
        auth: AppResolvers.auth
    ).when('/threads/:thread_id',
      templateUrl: '/static/partials/thread.html'
      controller: 'ThreadCtrl'
      resolve:
        thread: AppResolvers.thread
        auth: AppResolvers.auth
    ).when('/domains',
      templateUrl: '/static/partials/domains.html'
      controller: 'DomainsCtrl'
      resolve:
        domains: AppResolvers.domains
        auth: AppResolvers.auth
    ).when('/users',
      templateUrl: '/static/partials/users/list.html'
      controller: 'UsersListCtrl'
      resolve:
        users: AppResolvers.users
        auth: AppResolvers.auth
    ).when('/users/new',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
      resolve:
        auth: AppResolvers.auth
        user: AppResolvers.user
    ).when('/users/:user_id/:edit',
      templateUrl: '/static/partials/users/user.html'
      controller: 'UserCtrl'
      resolve:
        user: AppResolvers.user
        auth: AppResolvers.auth
    ).when('/login',
      templateUrl: '/static/partials/login.html'
      controller: 'SessionCtrl'
      resolve:
        auth: AppResolvers.auth
    ).otherwise(redirectTo: '/not_found')


window.app = angular
  .module('Firebrick', ['ngSanitize', 'ngRoute', 'ngResource', 'ngSanitize'])
  .config ['$routeProvider', '$locationProvider', '$httpProvider', config]
