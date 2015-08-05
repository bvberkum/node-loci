
console.log "Loading Loci"



# Backbone defines

# the view is two part: the root is a collectionview, but it never sees all
# nodes, instead it only sees the root node for which it creates a
# composite view. Each node on initialize creates a new collection for the
# sub-level.

TreeView = Backbone.Marionette.CompositeView.extend {

  template: "#node-template"
  tagName: "ul"

  initialize: ->
    @collection = @model.nodes
    null

  appendHtml: ( cv, iv ) ->
    cv.$('ul:first').append iv.el
    null

  onRender: ->
    null

}

TreeRootView = Backbone.Marionette.CollectionView.extend {
  childView: TreeView
}

# The tree node model initializes subnode collections
TreeNode = Backbone.Model.extend {
  initialize: ->
    nodes = @get "nodes"
    if nodes
      @nodes = new TreeNodeCollection nodes
      @unset "nodes"
    null
}

# The collection uses the tree node model
TreeNodeCollection = Backbone.Collection.extend {
  url: '/example-data'
  model: TreeNode
}


# init routines

initTree = ->
  treeCollection = new TreeNodeCollection
  treeView = new TreeRootView collection: treeCollection

  treeView.render()
  $('#tree').html(treeView.el)

  treeCollection.fetch()


initIO = ->
  sio = io.connect()

  # Emit ready event.
  sio.emit 'ready'

  # Listen for the talk event.
  sio.on 'talk', (data) ->
    $('#talk').html data.message


# Instantiate once ready
(( $ ) ->

  $(document).ready ->

    console.log "Starting Loci"

    initTree()
    initIO()

    console.log "Loci ready"

)(jQuery)

