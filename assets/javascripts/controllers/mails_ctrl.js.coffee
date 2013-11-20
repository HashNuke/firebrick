app.controller 'MailsCtrl', ($scope, SharedData)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Main"
