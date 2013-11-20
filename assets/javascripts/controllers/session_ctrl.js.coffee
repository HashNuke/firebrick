app.controller 'SessionCtrl', ($scope, $location, SharedData, Session, auth)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Firebrick"

  if auth.user
    $scope.sharedData.user = auth.user
    $location.path("/")
  else
    $scope.session = {username: "whatever", password: "akash"}

  $scope.login = ->
    successCallback = (data) ->
      $location.path("/")

    errorCallback = (response) =>
      console.log response.data
      #TODO handle errors

    Session.save($scope.session, successCallback, errorCallback)
