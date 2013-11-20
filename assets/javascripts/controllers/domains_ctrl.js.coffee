app.controller 'DomainsCtrl', ($scope, SharedData, Domain, domains)->
  $scope.sharedData = SharedData
  $scope.sharedData.title = "Domains"
  $scope.domains = domains

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
