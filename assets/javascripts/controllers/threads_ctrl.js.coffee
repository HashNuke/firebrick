app.controller 'ThreadsCtrl', ($scope, $route, SharedData, Thread, threads)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = ($route.current.params.category || "inbox")
  $scope.threads = threads
  console.log threads
