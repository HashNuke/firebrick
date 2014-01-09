App.DomainItemController = Em.ObjectController.extend
  actions:
    remove: ->
      domain = @get('model')
      domain.deleteRecord()
      successCallback  = =>
        console.log("deleted")
      errorCallback = =>
        console.log("error whatever...")
      domain.save().then(successCallback, errorCallback)
