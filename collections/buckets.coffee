@Buckets = new Meteor.Collection 'buckets'

Meteor.methods(
  makeBucket: (info)->
    b =
      which: info.which
      bucket: info.bucket
    Buckets.insert(b)

  deleteAll: ()->
    Buckets.remove({which:"countries"})
    Buckets.remove({which:"array"})
)
