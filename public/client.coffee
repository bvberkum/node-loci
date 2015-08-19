
console.log "Loading Loci"



# require client/view/tree-node



# Backbone defines

# the view is two part: the root is a collectionview, but it never sees all
# nodes, instead it only sees the root node for which it creates a
# composite view. Each node on initialize creates a new collection for the
# sub-level.

TreeNodeView = Backbone.Marionette.CompositeView.extend {

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

}

TreeView = Backbone.Marionette.CollectionView.extend {
  childView: TreeNodeView
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
  url: '/loci/data'
  model: TreeNode
}


# Patch to load external templates
Backbone.Marionette.TemplateCache.prototype.loadTemplate = ( templateId ) ->

  template = ''
  url = '/view/part/' + templateId

  # Load the template by fetching the URL content synchronously.
  Backbone.$.ajax
      async: false
      url: url
      success: ( templateHtml ) ->
          template = templateHtml

  return template


# Instruct Marionette to use Handlebars.
Marionette.TemplateCache.prototype.compileTemplate = ( template ) ->
  Handlebars.compile( template )


# init routines

initTree = ->
  treeCollection = new TreeNodeCollection
  treeView = new TreeView collection: treeCollection

  treeView.render()
  $('#collection').html(treeView.el)

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

