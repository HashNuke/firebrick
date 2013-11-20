app.controller 'SessionCtrl', ($scope, $location, SharedData, Session, auth)->
  $scope.sharedData = SharedData
  if auth.user
    $scope.sharedData.user = auth.user
    $location.path("/users")
  else
    $scope.session = {username: "whatever", password: "akash"}

  $scope.login = ->
    successCallback = (data) ->
      $location.path("/users")

    errorCallback = (response) =>
      console.log response.data
      #TODO handle errors

    Session.save($scope.session, successCallback, errorCallback)