app.controller 'RootCtrl', ($scope, $location, SharedData, Session, $rootScope)->
  $scope.sharedData = SharedData

  $scope.$on '$routeChangeSuccess', (scope, next, current)->
    if !current?
      $rootScope.landedOnCompose = true
    else
      $rootScope.landedOnCompose = false

  $scope.is_auth = ->
    SharedData.user?

  $scope.logout = ->
    successCallback = (data) ->
      console.log "logging you out ~!"
      SharedData.user = null
      $location.path("/login")

    errorCallback = (response) =>
      console.log response.data
      #TODO handle errors

    Session.delete({}, successCallback, errorCallback)
