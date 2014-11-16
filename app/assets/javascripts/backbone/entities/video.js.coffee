YoutubeEditor.module "Entities", (Entities, App) ->

	class Entities.Clip extends Entities.Model
      urlRoot: '/clips'

	class Entities.ClipCollection extends Entities.Collection
	  url: '/clips'
	  model: Entities.Clip

	API = 
      getClips: ->
      	clips = new Entities.ClipCollection()
      	clips.fetch()
      	clips
      
      getClip: (id) ->
        clip = new Entities.Clip({id: id})
        clip.fetch()
        clip

      getNewClip: (attrs={}) ->
        clip = new Entities.Clip(attrs)
        clip

  App.reqres.setHandler "clip:entities", API.getClips
  App.reqres.setHandler "clip:entity", (id) -> API.getClip(id)
  App.reqres.setHandler "new:clip:entity", (attrs) -> API.getNewClip(attrs)
