app.controller 'UserCtrl', ($scope, $route, $location, SharedData, Domain, User, user)->
  $scope.sharedData = SharedData
  #TODO should use a resolver

  domainsSuccessCallback = (data)->
    $scope.domains = data
    if !$scope.user.domain_id
      $scope.user.domain_id = $scope.domains[0].id

  domainsErrorCallback   = ()-> console.log("error")
  Domain.query(domainsSuccessCallback, domainsErrorCallback)

  if !$route.current.params.user_id
    $scope.sharedData.title = "New user"
  else
    $scope.sharedData.title = "Edit user"

  $scope.validRoles = ['admin', 'member']
  $scope.user = user

  $scope.saveUser = ->
    successCallback = (data) ->
      $location.path("/users")

    errorCallback = (response) =>
      console.log response.data
      #TODO handle errors

    if !$scope.user.id
      User.save($scope.user, successCallback, errorCallback)
    else
      user = $scope.user
      user.$update(successCallback, errorCallback)

