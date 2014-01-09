App.Domain = DS.Model.extend
  name: DS.attr("string")


App.User = DS.Model.extend
  username:  DS.attr("string")
  firstName: DS.attr("string")
  lastName:  DS.attr("string")
  role:      DS.attr("string", defaultValue: "member")
  domainId:  DS.attr("string")
  primaryAddress: DS.attr("string")


App.CurrentUser = App.User.extend({})


App.Thread = DS.Model.extend
  subject: DS.attr("string")
  createdAtDt: DS.attr("string")
  updatedAtDt: DS.attr("string")
  messageIds: DS.attr("array")
  mailPreviews: DS.attr("mailPreview")
  mailPreview: DS.attr("mailPreview")
  category: DS.attr("string")
  read: DS.attr("boolean")
  userId: DS.attr("string")
  timezone: DS.attr("string")