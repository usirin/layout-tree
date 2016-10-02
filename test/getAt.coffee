expect = require 'expect'
{ createTree, getAt, createNode, createParentNode } = require '../src'

describe 'getAt', ->

  it 'should return correct node', ->
    tree = createTree
      root: createParentNode
        orientation: 'vertical'
        children: [
          createNode id: 0
          createParentNode
            orientation: 'horizontal'
            children: [
              createNode id: 1
              createNode id: 2
              createNode id: 3
            ]
          createNode id: 4
          createNode id: 5
        ]

    node = getAt tree, 2
    expect(node.meta.id).toBe 2

    nonExistent = getAt tree, 10
    expect(nonExistent).toEqual null

