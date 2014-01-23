Template.index.events(
  'click #datsub': (e)->
    e.preventDefault()
    company = $('input[name="company"]').val()
    country = holydooley(company)
    if country is "nope"
      $('.company-result')[0].innerHTML = "Sorry, I don't know what that company is."
    else if country is "sorry"
      $('.company-result')[0].innerHTML = "Sorry, that company was founded earlier than our US GDP per capita dataset contains."
    else
      $('.company-result')[0].innerHTML = "Go to <span class='country'>"+country+"</span> to make another <span class='company'>"+company+"</span>"

  'click #dotsub': (e)->
    e.preventDefault()
    country = $('input[name="country"]').val()
    companies = findCompanies(country)
    if companies is "nope"
      $('.country-result h3')[0].innerHTML = "Sorry, I don't know what that country is."
    else
      $('.country-result h3')[0].innerHTML = "Based on current GDP per capita, " + country + " needs these companies:"
      $('.country-result ul').contents().remove()
      for c in companies
        $('.country-result ul').append("<li style='text-transform: capitalize;'>"+c+"</li>")
)

findCompanies = (country)->
  c = Countries.findOne({"Country Name": country})
  keys = Object.keys(c)
  filt = (x)->
    matched = String(x).match(/[0-9]+/)
    if String(x).match(/[0-9]+/) isnt null
      true
    else
      false
  filtered = keys.filter(filt)
  mostRecentYear = filtered.sort().slice(-1)
  debugger
  if mostRecentYear.length isnt 0
    # c[mostRecentYear] is a GDP, which needs to be rounded, then you need to find the year in which the US had that GDP. Then you can find which businesses have that founding year with a Business mongo query
    target_gdp = parseInt(c[mostRecentYear])
    usa = Countries.findOne({"Country Name": "United States"})
    moreKeys = Object.keys(usa)
    filtered = moreKeys.filter(filt)
    smallest = 1000000000000
    year = ""
    for f in filtered
      if Math.abs(usa[f] - target_gdp) < smallest
        smallest = Math.abs(usa[f] - target_gdp)
        year = f
    debugger
    targets = Businesses.find({"foundingDate": parseInt(year)}).fetch()
    comps = []
    for t in targets
      comps.push(t.name)
    return comps
  else
    return "nope"

holydooley = (company)->
  b = Businesses.findOne({name: company})
  unless b
    return "nope"
  usa = Countries.findOne({"Country Name":"United States"})
  if usa[b.foundingDate]
    target = usa[b.foundingDate]
  else
    return "sorry"

  closest = findClosest(target)
  sortedCountries = Buckets.findOne({which:"countries"})
  sortedCountries.bucket[closest]

findClosest = (target)->
  best = ["", 10000000]
  sortedArray = Buckets.findOne({which:"array"})
  for gdp in sortedArray.bucket
    diff = Math.abs(gdp - target)
    if diff < best[1]
      best[1] = diff
      best[0] = gdp

  best[0]

Template.index.rendered = ()->
  setTimeout(()->
    bus = Businesses.find({}).fetch()
    names = []
    for b in bus
      names.push(b.name)

    debugger
    $("#dat").autocomplete({ source: names, minLength: 3 })

    cnames = []
    counts = Countries.find({}).fetch()
    for c in counts
      cnames.push(c["Country Name"])
    $("#dot").autocomplete({ source: cnames, minLength: 2 })
  , 2000)
