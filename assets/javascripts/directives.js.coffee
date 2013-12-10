app.directive "composeButton", ->

  controller = ($scope)->
    $scope.showComposer = false
    $scope.openComposer = ->
      $scope.showComposer = true

  return {
    templateUrl: "/static/partials/compose.html"
    restrict: "E"
    controller: controller
  }
