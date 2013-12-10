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


app.directive "taggedInput", ->
  return {
    restrict: "E"
    template: """
      <div class="tagged-input-wrapper">
        <input class="tagged-input-value"></input>
        <div class="tagget-input-value-list"></div>
        <textarea class="tagged-input"></textarea>
      </div>
      """

    controller: ($scope)->
      angular.element(".tagged-input-wrapper").on("click", (event)-> $(".tagged-input").focus())

      angular.element(".tagged-input").on "keyup", (event)->
        # if enter key and some text entered, then add entry
        if event.which == 13
          if $(this).val().trim().length == 0
            $(this).val("")
            return

          newValue = "<div class='tag'>#{$(this).val()}</div>"
          $(".values").html($(".values").html() + newValue)
          $(this).val("")

        # if backspace & if no text, then delete last entry
        else if event.which == 8 && $(this).val().length == 0
          if($(".values").children().length > 0)
             $(".values").children()
             .eq($(".values").children().length - 1)
             .remove()
  }
