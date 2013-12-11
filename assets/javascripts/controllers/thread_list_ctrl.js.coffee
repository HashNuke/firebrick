app.controller 'ThreadListCtrl', ($scope, $location, $route, SharedData, Thread, threads)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = ($route.current.params.category || "inbox")
  $scope.threads = threads

  $scope.openThread = (threadId)->
    console.log threadId
    $location.path("/threads/#{threadId}")

