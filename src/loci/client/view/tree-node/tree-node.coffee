module.exports =

  baseType: Backbone.Marionette.CompositeView

  template: "url-tile"
  tagName: "div"

  initialize: ->
    @collection = @model.nodes
    null

  appendHtml: ( cv, iv ) ->
    cv.$('ul:first').append iv.el
    null

  onRender: ->
    null

