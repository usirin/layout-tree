expect = require 'expect'
createNode = require '../src/createNode'
createParentNode = require '../src/createParentNode'
createTree = require '../src/createTree'
{ Orientation } = require '../src/constants'

remove = require '../src/remove'

describe '#remove', ->

  describe 'when there is more than 2 children', ->

    it 'should remove child with given index', ->
      tree = createTree
        root: createParentNode
          meta: id: '0'
          orientation: Orientation.HORIZONTAL
          children: [
            createNode id: '00'
            createNode id: '01'
            createNode id: '02'
          ]

      tree = remove tree, 1

      expect(tree.root.children.length).toBe 2
      expect(tree.root.children[0].meta.id).toBe '00'
      expect(tree.root.children[1].meta.id).toBe '02'


  describe 'when there is 2 children', ->

    describe 'when parent is the root', ->

      it 'should remove the children and change itself to normal node as root', ->
        # this scenario means that we are returning from 2 split tab to a tab
        # with single window.
        tree = createTree
          root: createParentNode
            meta: id: '0'
            orientation: Orientation.HORIZONTAL
            children: [
              createNode id: '00'
              createNode id: '01'
            ]

        tree = remove tree, 1

        expect(tree.root.type).toBe 'node'
        expect(tree.root.meta.id).toBe '00'

    describe 'when parent is not the root', ->

      it 'should remove the children and change it', ->

        tree = createTree
          root: createParentNode
            meta: id: '0'
            orientation: Orientation.HORIZONTAL
            children: [
              createNode id: '00'
              createParentNode
                meta: id: '01'
                children: [
                  createNode id: '010'
                  createNode id: '011'
                ]
              createNode id: '02'
            ]

        tree = remove tree, 1

        expect(tree.root.children[1].type).toBe 'node'
        expect(tree.root.children[1].meta.id).toBe '011'


