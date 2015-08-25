
Code in public/client, sort into src.

loci/view/client/part/url-tile

to loci/client/view/url-tile.{jade,coffee}



current structure
  loci
    client
      view
        tree-node
        tree extends Backbone.Marionette.CompositeView
        url-tile extends tree-node
        url-tree ...
      model
        tree-node


tree-node corresponds to a record, tree to a root-node record.
need a container for the url-tile views too, url-tree

model pairs with tree-node view

need to setup a container for all these views to init collection
write a Loci view for this? maybe need a project name for the client build


