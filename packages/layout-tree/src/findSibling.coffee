{ Direction, Orientation } = require './constants'

# findParentWithOrientation:
# (Node, Orientation) => ParentNode | null
findParentWithOrientation = (node, orientation) ->
  return null  unless parent = node.parent
  return parent  if parent.orientation is orientation
  return findParentWithOrientation parent, orientation


# getOrientation:
# (Direction) => Orientation
getOrientation = (direction) ->
  if direction in [Direction.UP, Direction.DOWN]
  then Orientation.HORIZONTAL
  else Orientation.VERTICAL


# getSiblingIndex:
# (Direction, Number) => Number
getSiblingIndex = (direction, childIndex) ->
  if direction in [Direction.UP, Direction.LEFT]
  then childIndex - 1
  else childIndex + 1


# isRoot:
# (Node) => Boolean
isRoot = (node) -> not node.parent


# findChild:
# (ParentNode, Orientation, Direction, Number, ?Number) => Node
findChild = (parent, orientation, direction, index, relativeIndex = 0) ->

  { children } = parent
  index = Math.min(Math.max(0, index), children.length - 1)
  node = children[index]

  return node  if node.type is 'node'

  lastIndex = children.length - 1

  if orientation is node.orientation
    if direction in [Direction.LEFT, Direction.UP]
    then index = lastIndex
    else index = 0
  else
    index = Math.round(relativeIndex * children.length)

  return findChild node, orientation, direction, index, relativeIndex


# findSibling:
# (Node, Direction, Number, Node) => Node
findSibling = (node, direction, relativeIndex, initialNode) ->

  initialNode = node  unless initialNode?

  orientation = getOrientation(direction)
  parent = findParentWithOrientation(node, orientation)

  return initialNode  unless parent

  if parent isnt node.parent
    unless relativeIndex?
      relativeIndex = node.parent.indexOf(node) / (node.parent.children.length - 1)
    return findSibling(node.parent, direction, relativeIndex, initialNode)

  childIndex = parent.indexOf(node)
  childrenLength = parent.children.length
  newIndex = getSiblingIndex(direction, childIndex)

  if newIndex < 0 or newIndex > childrenLength - 1
    return initialNode  if isRoot parent
    return findSibling(parent, direction, relativeIndex, initialNode)

  return findChild parent, orientation, direction, newIndex, relativeIndex


module.exports = findSibling
