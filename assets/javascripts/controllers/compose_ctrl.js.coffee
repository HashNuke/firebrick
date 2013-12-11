app.controller 'ComposeCtrl', ($scope, $location, SharedData)->
  console.log "init", window.history
  $scope.sharedData = SharedData
  $scope.showComposer = false
  $scope.showOtherRecipients = false

  $scope.openComposer  = -> $scope.showComposer = true
  $scope.closeComposer = ->
    console.log "when close", window.history
    if window.history.length == 1
      console.log "go to index"
      $location.path("/")
    else
      window.history.back()
    $scope.showComposer = false
