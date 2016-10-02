Node = require './models/Node'
ParentNode = require './models/ParentNode'
Tree = require './models/Tree'

module.exports = split = (tree, index, orientation) ->

  node = tree.getAt index

  return tree  unless node

  clone = node.clone()

  # special case for initial split. When there is only root, no children.
  if node is tree.root
    newRoot = new ParentNode node.meta, orientation
    newRoot.attachChildren [node, clone]
    return new Tree newRoot

  unless parent = node.parent
    throw new Error '''
      something is really wrong, somehow even though node is not
      the root node, it still does not have a parent. And this
      should not happen.
      '''

  parent.splitChild node, orientation

  return new Tree tree.root


