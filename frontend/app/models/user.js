import DS from 'ember-data';

export default DS.Model.extend({
  username: DS.attr('string'),

  contacts: DS.hasMany('contact'),
  domain: DS.belongsTo('domain'),
  role: DS.belongsTo('user-role'),
  labels: DS.hasMany('mail-label')
});
