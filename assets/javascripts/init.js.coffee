window.Rinket = Ember.Application.create()

Rinket.ApplicationView = Ember.View.extend
  classNames: ['container']

Rinket.Router.map ->
  @resource('users')

Rinket.Router.map ->
  @resource('account')