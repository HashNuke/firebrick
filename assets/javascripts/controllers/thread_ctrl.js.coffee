app.controller 'ThreadCtrl', ($scope, $route, $location, SharedData, Thread, thread)->
  $scope.thread = thread
  $scope.sharedData = SharedData
  $scope.sharedData.title = "inbox"

