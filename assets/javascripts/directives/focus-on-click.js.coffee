app.directive "focusOnClick", ->
  return {
    restrict: "A"
    link: (scope, element, attrs)->
      element.on "click", (event)->
        element.find("textarea")[0].focus()
  }