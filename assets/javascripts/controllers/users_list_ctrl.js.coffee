app.controller 'UsersListCtrl', ($scope, SharedData, User, users)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Users"
  $scope.users = users

  $scope.removeUser = (index)->
    successCallback = -> $scope.users.splice(index, 1)
    errorCallback = ->
      #TODO handle errors
    $scope.users[index].$delete(successCallback, errorCallback)

  successCallback = (data)-> $scope.users = data
  errorCallback   = ()-> console.log("error")
