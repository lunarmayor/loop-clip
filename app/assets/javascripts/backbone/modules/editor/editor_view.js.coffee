YoutubeEditor.module 'Editor', (Editor, App) ->
  class Editor.InputView extends App.Views.ItemView
    template: 'editor/templates/editor_input'
    className: 'input-container'
    events: 
      'keyup input': 'checkURL'

    checkURL: ->
      q = @$el.find('input').val()

      if /youtube.com\/watch\?v=/.test(q)
        App.execute('show:editor', q)
        @$el.find('.error').hide()
      else
      	@$el.find('.error').text("This doesn't look like a valid url")

  class Editor.View extends App.Views.ItemView
    template: 'editor/templates/editor'
    className: 'editor'

    events:
      'click .share': 'saveClip'
      'click .permalink': -> window.location ="/clips/" + @model.get('id')

    saveClip: ->
      @model.save({}, success: (data) =>
        @$el.find('.permalink').text("Link: " + window.location.origin + '/clips/' + @model.get('id'))

      )

    
    onRender: ->
      tag = document.createElement('script')
      tag.src = "https://www.youtube.com/iframe_api"
      firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)
      
      view = @

      window.onYouTubeIframeAPIReady = ->
      	view.player = new YT.Player('player', {
          height: '390',
          width: '640',
          videoId: view.model.get('video_id'),
          events: {
          	onReady: -> view.setupPlayer()
          }
        })

    setupPlayer: ->
      that = this
      @checkEndTime(that)
      
      @model.attributes.start_time = 0
      @model.attributes.end_time = @player.getDuration()
      
      @$el.find('#range-slider').slider({
        range: true,
        min: 0,
        max: @player.getDuration(),
        values: [0, @player.getDuration()]
        step: 1
        slide: (event, ui) =>
          startChanged = (ui.value == ui.values[0])
          @model.attributes.start_time = ui.values[0]
          @model.attributes.end_time = ui.values[1]
          @updatePlayer() if startChanged
      })

      @player.playVideo()

    updatePlayer: ->
      @player.seekTo(@model.get('start_time'))

    checkEndTime: (view) =>
      requestAnimationFrame((=> @checkEndTime(view)))
      if view.player.getCurrentTime() > view.model.get('end_time')
      	view.player.seekTo(view.model.get('start_time'))


  class Editor.ShowView extends App.Views.ItemView
    template: 'editor/templates/show'
    className: 'editor'

    onRender: ->
      tag = document.createElement('script')
      tag.src = "https://www.youtube.com/iframe_api"
      firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)
      console.log(@model)
      view = @

      window.onYouTubeIframeAPIReady = ->
        view.player = new YT.Player('player', {
          height: '390',
          width: '640',
          playerVars: {
            'controls': 0,
            'start': view.model.get('start_time')
          },
          videoId: view.model.get('video_id'),
          events: {
            onReady: -> view.setupPlayer(),
            onStateChange: (e) ->
              console.log(e)
              if(e.data == 0)
              	view.player.seekTo(view.model.get('start_time'))
          }
        })

    setupPlayer: ->
      @checkEndTime(this)
      @player.playVideo()

    checkEndTime: (view) =>
      requestAnimationFrame((=> @checkEndTime(view)))
      if view.player.getCurrentTime() >= view.model.get('end_time')
      	view.player.seekTo(view.model.get('start_time'))


        



      

        
