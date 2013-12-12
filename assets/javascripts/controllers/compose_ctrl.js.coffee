app.controller 'ComposeCtrl', ($scope, $location, SharedData, $rootScope)->
  $scope.sharedData = SharedData
  $scope.showOtherRecipients = false

  $scope.openComposer  = -> $scope.showComposer = true
  $scope.closeComposer = ->
    if $rootScope.landedOnCompose
      $location.path("/")
    else
      window.history.back()
