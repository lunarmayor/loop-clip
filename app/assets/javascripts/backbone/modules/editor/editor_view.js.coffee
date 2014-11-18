YoutubeEditor.module 'Editor', (Editor, App) ->
  
  ###
  # View for managing Editor URL Input
  ###
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

  ###
  # View to manage Editor
  ###
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
      @player = new YT.Player(@$el.find('#player')[0], {
        height: '390',
        width: '640',
        videoId: @model.get('video_id'),
        events: {
          onReady: => @setupPlayer()
        }
      })

    setupPlayer: ->
      @checkEndTime(this)
      @setInitialRangeValues()
      @setupRangeSlider()
      @player.playVideo()

    setupRangeSlider: ->
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

    setInitialRangeValues: ->
      @model.attributes.start_time = 0
      @model.attributes.end_time = @player.getDuration()

    updatePlayer: ->
      @player.seekTo(@model.get('start_time'))

    checkEndTime: (view) =>
      requestAnimationFrame((=> @checkEndTime(view)))
      if view.player.getCurrentTime() > view.model.get('end_time')
      	view.player.seekTo(view.model.get('start_time'))

  ###
  # view to manage read only editor
  ###
  class Editor.ShowView extends App.Views.ItemView
    template: 'editor/templates/show'
    className: 'editor'

    onRender: ->
      @player = new YT.Player(@$el.find('#player')[0], {
        height: '390',
        width: '640',
        playerVars: {
          'controls': 0,
          'start': @model.get('start_time')
        },
        videoId: @model.get('video_id'),
        events: {
          onReady: => 
            @setupPlayer()
          onStateChange: (e) => 
            @player.seekTo(@model.get('start_time')) if e.data == 0
          }
        })

    setupPlayer: ->
      @checkEndTime(this)
      @player.playVideo()

    checkEndTime: (view) =>
      requestAnimationFrame((=> @checkEndTime(view)))
      if view.player.getCurrentTime() >= view.model.get('end_time')
      	view.player.seekTo(view.model.get('start_time'))


        



      

        
