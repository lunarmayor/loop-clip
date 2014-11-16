do ($) ->

  ## Attach Rails CSRF Token
  $.ajaxPrefilter (options, originalOptions, jqXHR)->
    token = $('meta[name=csrf-token]').attr('content')
    jqXHR.setRequestHeader 'X-CSRF-Token', token