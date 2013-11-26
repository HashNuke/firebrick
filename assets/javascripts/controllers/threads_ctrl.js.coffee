app.controller 'ThreadsCtrl', ($scope, SharedData, Thread, threads)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Threads"
  $scope.threads = threads
  console.log threads

