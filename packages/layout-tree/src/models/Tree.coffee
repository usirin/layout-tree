Node = require './Node'
{ getAt, traverse } = require '../getAt'
findSibling = require '../findSibling'

module.exports = class Tree

  constructor: (root) ->
    @type = 'tree'
    @setRoot root or new Node 'node', null, null


  setRoot: (root) -> @root = root


  getAt: (index) -> getAt this, index


  traverse: (traverserFn) -> traverse @root, traverserFn


  indexOf: (node) ->

    index = -1
    @traverse (child, i) -> index = i  if child is node

    return index


  findSibling: (node, direction) ->

    return null  if @indexOf(node) < 0

    if @indexOf(sibling = findSibling(node, direction)) > 0
    then sibling
    else null


