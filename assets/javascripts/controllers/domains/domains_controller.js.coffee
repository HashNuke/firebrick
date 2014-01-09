App.DomainsController = Em.ArrayController.extend
  needs: ["application"]
  itemController: "DomainItem"

  actions:
    add: ->
      newDomain = @store.createRecord("domain", {name: @get("newDomainName")})
      successCallback = =>
        console.log("saved")
        @set("newDomainName", "")
      errorCallback = =>
        console.log("error adding domain")
      newDomain.save().then(successCallback, errorCallback)
