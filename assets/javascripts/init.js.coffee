$ ->
  window.Rinket = Ember.Application.create()
  Rinket.Router.map ->
    @resource('users')
