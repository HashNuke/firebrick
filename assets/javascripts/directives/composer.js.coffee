app.directive "composer", ->
  controller = ($scope)->
    $scope.showComposer = false
    $scope.showOtherRecipients = false

    $scope.openComposer  = -> $scope.showComposer = true
    $scope.closeComposer = -> $scope.showComposer = false


  return {
    templateUrl: "/static/partials/compose.html"
    restrict: "A"
    controller: controller
  }
