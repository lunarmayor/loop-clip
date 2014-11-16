YoutubeEditor.module "Views", (Views, App, Backbone, Marionette, $, _) ->
	
	_.extend Marionette.View::,
	
		templateHelpers: ->

      imageTag: (fileName) ->
        "<img src='assets/#{fileName}'/>"

