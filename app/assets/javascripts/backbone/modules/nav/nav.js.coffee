YoutubeEditor.module "Nav", (Nav, App) ->

  API =
    setupNav: ->
      navView = new Nav.View()
      App.navRegion.show(navView)
      
  Nav.on 'start', ->
    API.setupNav()