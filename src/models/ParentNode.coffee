Node = require './Node'
{ getAt, traverse } = require '../getAt'

module.exports = class ParentNode extends Node

  constructor: (meta, orientation) ->
    super 'parent', meta, orientation
    @children = []

  attachChildren: (children) ->
    @children = children.map (child) => child.setParent this
    return this

  indexOf: (child) -> @children.indexOf child

  splitChild: (child, orientation) ->
    index = @indexOf child
    clone = child.clone()

    if orientation isnt @orientation
      parent = new ParentNode @meta, orientation
      parent.attachChildren [child, clone]
      toBeInserted = [parent]
    else
      toBeInserted = [child, clone]

    @children.splice(index, 1, toBeInserted...)


  removeChild: (child) ->
    @children = @children.filter (c) -> c isnt child


