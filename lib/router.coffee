Router.configure
  before: clearErrors
  loadingTemplate: 'loading'

Router.map ->
  @route 'index',
    loadingTemplate: 'loading'
    path: '/'
    data: ()->
      debugger
      businesses: Businesses.find({}).fetch()
      countries: Countries.find({}).fetch()

clearErrors = ()->
  Errors.clearSeen()
