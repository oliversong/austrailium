# Austrailium

Find niche markets by comparing nations along a GDP per capita and time scale.

Basically, you put in a company name and we give you the country you should go to to found that kind of company right now.

Company founding dataset from: http://bear.warrington.ufl.edu/ritter/foundingdates.htm

GDP per capita dataset from: http://data.worldbank.org/indicator/NY.GDP.PCAP.CD

## Strategy

### Data structure

Make a sorted list of countries based on GDPPC, keep in Mongo as collection. Does Mongo have a $nearest operator?

```
sortedCountries = {
  148591124: 'United States',
  1283495: 'Geneva'
}
sortedArray = Object.keys(sortedCountries).sort()
```

Need to be able to find the country that's closest to a target GDPPC. Use a binary search through sortedArray to find the closest GDPs (maybe 10 closest ones?), then index into sortedCountries to return a list of the country names.

Keep these in memory, recalculate every time the server is started
```
countries = Countries.find({}).fetch()
sortedCountries = {}
for country in countries
  sortedCountries[country.GDP.2013] = country.name

sortedArray = Object.keys(sortedCountry).sort()
```

### Mongo imports

For GDP information
```
mongoimport -h localhost:3002 --db meteor --collection countries --type csv --file ./public/gdppc2.csv --headerline --ignoreBlanks
```

For founding date information (public companies only)
```
mongoimport -h localhost:3002 --db meteor --collection businesses --type csv --file ./public/foundingdates3.csv --headerline
```

## Todo

* Autocomplete
* Give a range of the best matches
* Which companies do each of the countries need?
