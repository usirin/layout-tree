exports.getAt = getAt = (tree, index) ->
  node = null
  traverse tree.root, (leaf, i) ->
    node = leaf  if i is index
  return node

exports.traverse = traverse = (root, itemFn) ->

  traverseChildren = do (index = 0) -> (node) ->
    if node.children
      return node.children.forEach(traverseChildren)
    itemFn node, index++

  traverseChildren root

