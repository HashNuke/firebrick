app.controller 'SessionCtrl', ($scope, $location, SharedData, Session, auth)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Firebrick"
  $scope.loginLabel = "Login"

  if auth.user? && !auth.user.error?
    $scope.sharedData.user = auth.user
    $location.path("/")
  else
    $scope.session = {username: "whatever", password: "akash"}

  $scope.login = ->
    successCallback = (data) ->
      if data.user?
        $location.path("/")
      else
        $scope.errorNotification = "Check your credentials"
        $scope.loginLabel = "Login again"

    errorCallback = (response) =>
      $scope.errorNotification = "Oops ~! something went wrong"
      $scope.loginLabel = "Login again"

    Session.save($scope.session, successCallback, errorCallback)
