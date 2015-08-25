
console.log "Loading Loci"


# require client/view/tree-node
# require client/view/tree


# require client/model/tree-node
# require client/model/tree


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

