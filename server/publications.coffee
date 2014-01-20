Meteor.publish 'businesses', ()->
  return Businesses.find()

Meteor.publish 'countries', ()->
  return Countries.find()

Meteor.publish 'buckets', ()->
  return Buckets.find()
