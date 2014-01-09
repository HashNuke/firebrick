App.MailPreviewTransform = DS.Transform.extend
  deserialize: (serialized)->
    return serialized

  serialize: (deserialized)->
    return deserialized


App.MailPreviewsTransform = DS.Transform.extend
  deserialize: (serialized)->
    return serialized

  serialize: (deserialized)->
    return deserialized


App.ArrayTransform = DS.Transform.extend
  deserialize: (serialized)->
    return serialized if Em.typeOf(serialized) == "array"
    []

  serialize: (deserialized)->
    return deserialized if Em.typeOf(deserialized) == 'array'
    []