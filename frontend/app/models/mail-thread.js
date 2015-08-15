import DS from 'ember-data';

export default DS.Model.extend({
  subject: DS.attr('string'),

  user: DS.belongsTo('user'),
  participants: DS.hasMany('contact'),
  mails: DS.hasMany('mail'),
  labels: DS.hasMany('mail-labels'),

  createdAt: DS.attr('date'),
  updatedAt: DS.attr('date')
});
