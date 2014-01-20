Router.configure
  before: clearErrors
  loadingTemplate: 'loading'

Router.map ->
  @route 'index',
    loadingTemplate: 'loading'
    path: '/'

clearErrors = ()->
  Errors.clearSeen()
