if Meteor.isServer
  Meteor.startup(()->
    countries = Countries.find({}).fetch()
    sortedCountries = {}
    filt = (x)->
      matched = String(x).match(/[0-9]+/)
      if String(x).match(/[0-9]+/) isnt null
        true
      else
        false
    for country in countries
      keys = Object.keys(country)
      filtered = keys.filter(filt)
      mostRecentYear = filtered.sort().slice(-1)
      if mostRecentYear.length isnt 0
        sortedCountries[parseInt(country[mostRecentYear])] = country["Country Name"]

    sortedArray = Object.keys(sortedCountries).sort()
    Meteor.call('deleteAll')
    Meteor.call('makeBucket',
      which: 'countries'
      bucket: sortedCountries
    )
    Meteor.call('makeBucket',
      which: 'array'
      bucket: sortedArray
    )
  )
