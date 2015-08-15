import DS from 'ember-data';

export default DS.Model.extend({
  mailThread: DS.belongsTo('mail-thread'),
  from: DS.belongsTo('contact'),
  to: DS.hasMany('contact'),
  cc: DS.hasMany('contact'),
  bcc: DS.hasMany('contact'),

  subject: DS.attr('string'),
  plainBody: DS.attr('string'),
  htmlBody: DS.attr('string'),

  createdAt: DS.attr('date')
});
