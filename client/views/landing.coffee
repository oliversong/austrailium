Template.index.events(
  'click .submit': (e)->
    e.preventDefault()
    company = $('input[name="company"]').val()
    country = holydooley(company)
    if country is "nope"
      $('.result')[0].innerHTML = "Sorry, I don't know what that company is."
    else if country is "sorry"
      $('.result')[0].innerHTML = "Sorry, that company was founded earlier than our US GDP per capita dataset contains."
    else
      $('.result')[0].innerHTML = "Go to <span class='country'>"+country+"</span> to make another <span class='company'>"+company+"</span>"
)

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

    $("#dat").autocomplete({ source: names, minLength: 3 })
  , 2000)
