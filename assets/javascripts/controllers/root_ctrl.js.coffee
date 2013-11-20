app.controller 'RootCtrl', ($scope, $location, SharedData, Session)->
  $scope.sharedData = SharedData


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
