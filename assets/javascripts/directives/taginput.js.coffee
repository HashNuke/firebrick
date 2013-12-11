app.directive "taginput", ->
  return {
    restrict: "E"
    template: """<input></input>"""

    controller: ($scope, $element, $attrs, $sanitize)->
      $scope.values = []
      $element.parent().on("click", (event)-> $element.find("input")[0].focus())

      $element.find("input").on "keyup", (event)->
        # if enter key and some text entered, then add entry
        if event.keyCode == 13
          input = $element.find("input")
          list  = $element.find("span")
          if input.val().trim().length == 0
            input.val("")
            return
          newValue = input.val().trim()
          tag = angular.element("<span>").addClass("tag").text(newValue)
          $element[0].insertBefore(tag[0], $element.find("input")[0])
          $scope.values.push(newValue)
          input.val("")

        # if backspace & if no text, then delete last entry
        else if event.keyCode == 8
          list  = $element.find("span")
          input = $element.find("input")
          if list.length > 0 && input.val().length == 0
             list.eq(list.length - 1)
             .remove()
             $scope.values.pop()
  }
