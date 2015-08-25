module.exports =

  initialize: ->
    nodes = @get "nodes"
    if nodes
      @nodes = new TreeNodeCollection nodes
      @unset "nodes"
    null

