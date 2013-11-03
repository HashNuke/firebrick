window.Rinket = Ember.Application.create()

Rinket.ApplicationView = Ember.View.extend
  classNames: ['container']

Rinket.Router.map ->
  @resource('users')
  @resource('account')


Rinket.MenuControl = Ember.View.extend
  click: (evt)->
    $(".menu-pane").toggleClass('show-sidebar')
