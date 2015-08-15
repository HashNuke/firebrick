import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  labelType: DS.attr('string'),

  user: DS.belongsTo('user'),
  mailThreads: DS.hasMany('mail-thread')
});
