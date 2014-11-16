Backbone.Marionette.Renderer.render = (template, data) ->
  path = JST["backbone/modules/" + template]
  unless path
    throw "Template #{template} not found!"
  path(data)

Backbone.old_sync = Backbone.sync
Backbone.sync = (method, model, options) ->
  new_options = _.extend(
    beforeSend: (xhr) ->
      token = $("meta[name=\"csrf-token\"]").attr("content")
      xhr.setRequestHeader "X-CSRF-Token", token  if token
      return
  , options)
  Backbone.old_sync method, model, new_options