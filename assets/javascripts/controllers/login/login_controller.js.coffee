App.LoginController = Em.Controller.extend
  needs: ["application"]
  username: "admin"
  password: "password"

  actions:
    login: ->
      data = @getProperties('username', 'password')
      Em.$.post("/api/sessions", data).then (response)=>
        if response.error
          console.log "error", response
        else
          user = @store.createRecord('user', response.user)
          @set("controllers.application.currentUser", user)
          @transitionToRoute('threads.in', 'inbox')
