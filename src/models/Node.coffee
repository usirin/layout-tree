
module.exports = class Node

  constructor: (type, meta = {}, orientation = null) ->
    @type = type
    @orientation = orientation
    @meta = meta
    @parent = null

  setParent: (parent) ->
    @parent = parent
    return this

  clone: ->
    newNode = new Node @type, @meta, @orientation
    newNode.setParent @parent  if @parent

    return newNode
