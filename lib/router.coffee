Router.configure
  before: clearErrors
  loadingTemplate: 'loading'
  layoutTemplate: 'layout'

Router.map ->
  @route 'landingPage',
    layoutTemplate: 'layout'
    loadingTemplate: 'loading'
    path: '/'

clearErrors = ()->
  Errors.clearSeen()
