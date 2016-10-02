expect = require 'expect'
{ createTree, createNode, createParentNode } = require '../src'
findSibling = require '../src/findSibling'
{ Direction, Orientation } = require '../src/constants'

describe '#findSibling', ->
  describe 'with relatively simple tree', ->

    ###
    *---------*---------*---------*---------*
    |         |         |         |         |
    |         |    1    |         |         |
    |         |         |         |         |
    *         *---------*         *         *
    |         |         |         |         |
    |    0    |    2    |    4    |    5    |
    |         |         |         |         |
    *         *---------*         *         *
    |         |         |         |         |
    |         |    3    |         |         |
    |         |         |         |         |
    *---------*---------*---------*---------*
    ###
    tree = createTree
      root: createParentNode
        orientation: Orientation.VERTICAL
        children: [
          createNode id: 0
          createParentNode
            orientation: Orientation.HORIZONTAL
            children: [
              createNode id: 1
              createNode id: 2
              createNode id: 3
            ]
          createNode id: 4
          createNode id: 5
        ]

    it.only 'should  sibling of given direction', ->
      node = tree.getAt(2)
      sibling = findSibling(node, Direction.UP)
      expect(sibling.meta.id).toEqual 1

    it 'should  itself if there is no sibling of given direction', ->
      node = tree.getAt(0)
      sibling = findSibling(node, Direction.UP)
      expect(sibling.meta.id).toEqual 0
      sibling = findSibling(node, Direction.LEFT)
      expect(sibling.meta.id).toEqual 0

    it 'should handle a complex movement where parent orientation is different than direction', ->
      node = tree.getAt(0)
      sibling = findSibling(node, Direction.LEFT)
      expect(sibling.meta.id).toEqual 0

    it 'should choose relative index on ambigous finds', ->
      node = tree.getAt(0)
      sibling = findSibling(node, Direction.RIGHT)
      expect(sibling.meta.id).toEqual 1


  describe 'with a complex tree', ->
    p = createParentNode
    n = createNode
    tree = createTree(root: p(
      meta: id: '_root'
      orientation: Orientation.HORIZONTAL
      children: [
        p(
          meta: id: '0'
          orientation: Orientation.VERTICAL
          children: [
            n(id: '00')
            p(
              meta: id: '01'
              orientation: Orientation.HORIZONTAL
              children: [
                n(id: '010')
                n(id: '011')
              ])
          ])
        p(
          meta: id: '1'
          orientation: Orientation.VERTICAL
          children: [
            n(id: '10')
            p(
              meta: id: '11'
              orientation: Orientation.HORIZONTAL
              children: [
                p(
                  meta: id: '110'
                  orientation: Orientation.VERTICAL
                  children: [
                    n(id: '1100')
                    n(id: '1101')
                  ])
                n(id: '111')
                p(
                  meta: id: '112'
                  orientation: Orientation.VERTICAL
                  children: [
                    n(id: '1120')
                    p(
                      meta: id: '1121'
                      orientation: Orientation.HORIZONTAL
                      children: [
                        n(id: '11210')
                        n(id: '11211')
                      ])
                  ])
              ])
            p(
              meta: id: '12'
              orientation: Orientation.HORIZONTAL
              children: [
                n(id: '120')
                p(
                  meta: id: '121'
                  orientation: Orientation.VERTICAL
                  children: [
                    n(id: '1210')
                    n(id: '1211')
                  ])
              ])
          ])
      ]))

    ###
    *---------*---------*---------*---------*---------*
    |                   |                             |
    |                   |             010             |
    |                   |                             |
    *        00         *---------*---------*---------*
    |                   |                             |
    |                   |             011             |
    |                   |                             |
    *---------*---------*---------*---------*---------*
    |         |         |         |                   |
    |         |         |         |                   |
    |         |         |         |                   |
    *         *  1100   *  1101   *        120        *
    |         |         |         |                   |
    |         |         |         |                   |
    |         |         |         |                   |
    *   10    *---------*---------*---------*---------*
    |         |                   |         |         |
    |         |        111        |         |         |
    |         |                   |         |         |
    *         *---------*---------*  1210   *  1211   *
    |         |         |  11210  |         |         |
    |         |  1120   *---------*         |         |
    |         |         |  11211  |         |         |
    *---------*---------*---------*---------*---------*
    ###

    describe 'serial movements which will walk all the tree', ->
      node = null
      it 'starts at 00', ->
        node = tree.getAt(0)
        expect(node.meta.id).toEqual '00'

      it 'moves to 10', ->
        node = tree.getAt(0)
        node = findSibling(node, Direction.DOWN)
        expect(node.meta.id).toEqual '10'

      it 'moves to 1100', ->
        node = findSibling(node, Direction.RIGHT)
        expect(node.meta.id).toEqual '1100'

      it 'moves to 00', ->
        node = findSibling(node, Direction.UP)
        expect(node.meta.id).toEqual '00'

      it 'moves to 010', ->
        node = findSibling(node, Direction.RIGHT)
        expect(node.meta.id).toEqual '010'

      it 'moves to 011', ->
        node = findSibling(node, Direction.DOWN)
        expect(node.meta.id).toEqual '011'

      it 'moves to 120', ->
        node = findSibling(node, Direction.DOWN)
        expect(node.meta.id).toEqual '120'

      it 'moves to 1210', ->
        node = findSibling(node, Direction.DOWN)
        expect(node.meta.id).toEqual '1210'

      it 'stays at to 1210', ->
        node = findSibling(node, Direction.DOWN)
        expect(node.meta.id).toEqual '1210'

      it 'moves to 11211', ->
        node = findSibling(node, Direction.LEFT)
        expect(node.meta.id).toEqual '11211'

      it 'moves to 1120', ->
        node = findSibling(node, Direction.LEFT)
        expect(node.meta.id).toEqual '1120'

      it 'moves to 111', ->
        node = findSibling(node, Direction.UP)
        expect(node.meta.id).toEqual '111'

      it 'moves to 1210', ->
        node = findSibling(node, Direction.RIGHT)
        expect(node.meta.id).toEqual '1210'

      it 'moves to 120', ->
        node = findSibling(node, Direction.UP)
        expect(node.meta.id).toEqual '120'

      it 'moves to 1101', ->
        node = findSibling(node, Direction.LEFT)
        expect(node.meta.id).toEqual '1101'

      it 'moves to 111', ->
        node = findSibling(node, Direction.DOWN)
        expect(node.meta.id).toEqual '111'

      it 'moves to 1120', ->
        node = findSibling(node, Direction.DOWN)
        expect(node.meta.id).toEqual '1120'

      it 'moves to 11210', ->
        node = findSibling(node, Direction.RIGHT)
        expect(node.meta.id).toEqual '11210'

      it 'moves to 11211', ->
        node = findSibling(node, Direction.DOWN)
        expect(node.meta.id).toEqual '11211'

      it 'moves to 1210', ->
        node = findSibling(node, Direction.RIGHT)
        expect(node.meta.id).toEqual '1210'

      it 'moves to 1211', ->
        node = findSibling(node, Direction.RIGHT)
        expect(node.meta.id).toEqual '1211'

      it 'moves to 120', ->
        node = findSibling(node, Direction.UP)
        expect(node.meta.id).toEqual '120'

      it 'moves to 011', ->
        node = findSibling(node, Direction.UP)
        expect(node.meta.id).toEqual '011'

      it 'moves to 00', ->
        node = findSibling(node, Direction.LEFT)
        expect(node.meta.id).toEqual '00'


