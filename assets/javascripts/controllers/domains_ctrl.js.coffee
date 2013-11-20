app.controller 'DomainsCtrl', ($scope, SharedData, Domain)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Domains"

  $scope.addDomain = ->
    Domain.save $scope.newDomain, (data)->
      if data["errors"]
        #TODO handle errors
      else
        $scope.domains.push($scope.newDomain)
        $scope.newDomain = {}

  #TODO do not allow deleting domain if it has users
  $scope.removeDomain = (index)->
    successCallback = -> $scope.domains.splice(index, 1)
    errorCallback = ->
      #TODO handle errors
    $scope.domains[index].$delete(successCallback, errorCallback)

  successCallback = (data)-> $scope.domains = data
  errorCallback   = ()-> console.log("error")
  Domain.query(successCallback, errorCallback)

