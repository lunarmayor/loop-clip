YoutubeEditor.module "Editor", (Editor, App) ->

  class Editor.Router extends Marionette.AppRouter
  	appRoutes:
  	  "clips/:id": 'setupShow'
  	  "": 'setupEditorInput'

  API =
    setupEditorInput: ->
      EditorInputView = new Editor.InputView()
      App.mainRegion.show(EditorInputView)

    setupShow: (id) ->
      clip = App.request('clip:entity', id)
      showView = new Editor.ShowView(model: clip)
      App.mainRegion.show(showView)
    
    setupEditor: (videoId) ->
      clip = App.request('new:clip:entity', {video_id: videoId} )
      editorView = new Editor.View(model: clip)
      App.mainRegion.show(editorView)
      
  App.addInitializer ->
    new Editor.Router(controller: API)

  App.commands.setHandler('show:editor', (url) ->
    videoId = url.match(/[^=]*$/)[0]
    API.setupEditor(videoId)
  )

