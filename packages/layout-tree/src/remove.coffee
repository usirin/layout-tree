Tree = require './models/Tree'

module.exports = remove = (tree, index) ->

  node = tree.getAt index

  # we are at root return itself.
  return tree  unless parent = node.parent

  parent.removeChild node

  if parent.children.length is 1
    # this means that the parent is actually the root, and we need to replace
    # to root with the remaining children to preserve the parallelism with
    # split.
    unless parent.parent
      return new Tree parent.children[0]

    # replace parent with the remaining child inside parent's parent.
    parentIndex = parent.parent.indexOf parent
    parent.parent.children[parentIndex] = parent.children[0]

  return new Tree tree.root

