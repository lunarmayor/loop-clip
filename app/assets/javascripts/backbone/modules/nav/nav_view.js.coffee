YoutubeEditor.module 'Nav', (Nav, App) ->
  class Nav.View extends App.Views.ItemView
    template: 'nav/templates/nav'
    events:
     'click .brand': -> window.location = '/'