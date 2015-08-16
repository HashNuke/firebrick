import Ember from 'ember';

export default Ember.Route.extend({

  model(params) {
    let mailThread = this.store.find('mail-thread', params.id);
    return mailThread;
  }

});
