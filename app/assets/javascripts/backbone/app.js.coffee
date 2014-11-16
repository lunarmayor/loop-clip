@YoutubeEditor = do (Backbone, Marionette) ->
  
  App = new Marionette.Application

  App.addRegions
    navRegion: '#nav'
    mainRegion: "#main"

  App.addInitializer ->
    App.module('Nav').start()

  App.on "start", (options) ->
    if Backbone.history
      Backbone.history.start({pushState: true})

  App