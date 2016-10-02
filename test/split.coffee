expect = require 'expect'
{ Orientation: { VERTICAL, HORIZONTAL } } = require '../src/constants'
{ split, createTree, createNode, createParentNode, getAt } = require '../src'

describe 'split', ->

  describe 'when there is only root', ->
    it 'should work correctly', ->

      tree = createTree()
      tree = split tree, 0, VERTICAL

      expect(tree.root.type).toEqual 'parent'
      expect(tree.root.children.length).toEqual 2
      expect(tree.root.children[0].parent).toEqual tree.root
      expect(tree.root.children[1].parent).toEqual tree.root
      expect(tree.root.children[0].type).toEqual 'node'
      expect(tree.root.children[1].type).toEqual 'node'


  describe 'when the root is vertically splitted', ->

    _tree = null

    beforeEach ->
      _tree = createTree
        root: createParentNode
          orientation: 'vertical'
          children: [
            createNode id: 0
            createNode id: 1
          ]


    it 'should have 3 children under root if split is vertical', ->

      tree = split _tree, 0, 'vertical'

      expect(tree.root.children.length).toBe 3

      expect(tree.root.children[0].meta.id).toBe 0
      expect(tree.root.children[1].meta.id).toBe 0
      expect(tree.root.children[2].meta.id).toBe 1


    it 'should have correct structure with a horizontal split', ->

      tree = split _tree, 0, 'horizontal'

      expect(tree.root.orientation).toBe 'vertical'
      expect(tree.root.children.length).toBe 2

      expect(tree.root.children[0].type).toBe 'parent'
      expect(tree.root.children[1].type).toBe 'node'


    it 'should handle complex splits', ->

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

      tree = split tree, 2, 'horizontal'

      expect(tree.root.children[1].children.length).toBe 4

