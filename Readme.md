# layout-tree

Data structure for laying out splitted windows.

## What?

A data structure and collection of operations around this data structure to
represent set of windows in an efficient way.

## Example

Imagine you want to show a layout as below:

```
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
```

You could then use `layout-tree` as follows:

```js
import { createTree, createParentNode, createNode } from 'layout-tree'
import { Orientation } from 'layout-tree/lib/constants'

const tree = createTree({
  root: createParentNode({
    orientation: Orientation.VERTICAL,
    children: [
      createNode({ id: 0 }),
      createParentNode({
        orientation: Orientation.HORIZONTAL,
        children: [
          createNode({ id: 1 }),
          createNode({ id: 2 }),
          createNode({ id: 3 })
        ]
      }),
      createNode({ id: 4 }),
      createNode({ id: 5 })
    ]
  })
})
```

And you can easily read the leaf nodes by using `getAt` function exported from
`layout-tree`. Following the example above:

```js
import { getAt } from 'layout-tree'

// tree is the tree from example above.
const node = getAt(tree, 1)
// => Node(id: 1) {
//      type: 'node',
//      orientation: null,
//      meta: { id: 1 },
//      parent: ParentNode {
//        type: 'parent',
//        orientation: 'horizontal',
//        children: [ Node(id: 1), Node(id: 2), Node(id: 3) ]
//      }
//    }
```

## Constants

### Orientation

**Orientation** represents the way a `ParentNode` lays out its children.

```typescript
declare type Orientation = {
  HORIZONTAL: 'horizontal',
  VERTICAL: 'vertical'
}
```

### Direction

**Direction** represents the relative position of a sibling `Node`.

```typescript
declare type Direction = {
  UP: 'up',
  DOWN: 'down',
  LEFT: 'left',
  RIGHT: 'right'
}
```

Both `Direction` and `Orientation` are exported at top level:

```js
import { Direction, Orientation } from 'layout-tree'
```

## Models

### Node

**Node** is the base class of all other types of nodes (currently only
`ParentNode` with `type === 'parent'`). It declares the node interface.

```typescript
declare interface NodeInterface {
  type: string;
  orientation: Orientation | null;
  meta: Object;
  parent: ParentNode | null;

  setParent(parent: ParentNode): Node;
  clone(): Node;
}
```

```typescript
declare class Node implements NodeInterface {
  type: 'node';
  orientation: null;
  meta: Object<string, any>;
  parent: ParentNode | null;
}
```

There are 2 ways of creating a simple node:

1 - You can use the `createNode` factory function:

```js
import { createNode } from 'layout-tree'

const node = createNode({ name: 'foo' })
// => Node {
//     type: 'node',
//     orientation: null,
//     meta: { name: 'foo' },
//     parent: null
//   }
```

2 - You can use the `Node` class:

```js
import { Node } from 'layout-tree'

// You need to pass type as first argument to the constructor.
const node = new Node('node', { name: 'foo' })
// => Node {
//     type: 'node',
//     orientation: null,
//     meta: { name: 'foo' },
//     parent: null
//   }
```

`createNode` is the _correct_ way of creating a node, as you can see `Node`
class does not necessarily creates a node with the type of `node`.

### ParentNode

**ParentNode** is a different type of node to distinguish it from regular node instances.

```typescript
declare class ParentNode implements NodeInterface {
  type: 'parent';
  orientation: Orientation; // orientation has to be an Orientation type.
  meta: Object<string, any>;
  parent: ParentNode | null;
  children: Array; // adds a children member.

  attachChildren(children: Array<NodeInterface>): ParentNode;
  indexOf(child: NodeInterface): number;
  splitChild(child: NodeInterface, orientation: Orientation): void;
  removeChild(child: NodeInterface): Array<NodeInterface>;
}
```

There are 2 ways of creating a parent node:

1 - You can use the `createParentNode` factory function:

```js
import {
  createParentNode,
  createNode,
  Orientation
} from 'layout-tree'

const parent = createParentNode({
  orientation: Orientation.HORIZONTAL,
  children: [
    createNode({ name: 'child_0' }),
    createNode({ name: 'child_1' })
  ]
})
// => ParentNode {
//      type: 'parent',
//      orientation: 'horizontal',
//      meta: {},
//      parent: null,
//      children: [{
//        type: 'node',
//        orientation: null,
//        meta: { name: 'child_0' }
//        parent: [Circular]
//      }, {
//        type: 'node',
//        orientation: null,
//        meta: { name: 'child_1' }
//        parent: [Circular]
//      }]
//    }
```

2 - You can use the `ParentNode` class:

```js
import { Node, ParentNode, Orientation } from 'layout-tree'

const parent = new ParentNode(null, Orientation.HORIZONTAL)
parent.attachChildren([
  new Node('node', { name: 'child_0' }),
  new Node('node', { name: 'child_1' })
])
// => ParentNode {
//      type: 'parent',
//      orientation: 'horizontal',
//      meta: {},
//      parent: null,
//      children: [{
//        type: 'node',
//        orientation: null,
//        meta: { name: 'child_0' }
//        parent: [Circular]
//      }, {
//        type: 'node',
//        orientation: null,
//        meta: { name: 'child_1' }
//        parent: [Circular]
//      }]
//    }
```

`createParentNode` is the _correct_ way of creating a parent node, as using
constructor will require you to attach the children manually after creating a
parent node.

### Tree

**Tree** is the main data structure `layout-tree` package exports.

```typescript
declare type Traverser = (child: NodeInterface, index: number): void;
declare type RootNode = ParentNode | Node;

declare class Tree {
  type: 'tree';
  root: RootNode;
  constructor(root: NodeInterface);
  getAt(index: number): NodeInterface | null;
  traverse(traverserFn: Traverser): void;
  indexOf(node: NodeInterface): number;
  findSibling(node: NodeInterface, direction: Direction): NodeInterface | null;
}
```

Use `createTree` function to create a `layout-tree`:

```js
import { createTree } from 'layout-tree'

const tree = createTree()
// => Tree {
//      type: 'tree',
//      root: Node {
//        type: 'node',
//        orientation: null,
//        meta: null,
//        parent: null
//      }
//    }
```

Which will represent a tab with a single window:

```
*---------*
|         |
|    0    |
|         |
*---------*
```

## Operations

Most of the power of this data structures comes from its operations. Each
operation modifies the current tree structure, causes a new tree to be
returned.

There are 2 operations causes the current tree to be modified:

### split

```typescript
declare function split(tree: Tree, index: number, Orientation): Tree;
```

`split` will accept a [`Tree`](#tree) instance along with an `index` and an
[`Orientation`](#orientation) constant.

**split** operation **creates** a new child, therefore **increases** the
children count.

```js
import { createTree, split } from 'layout-tree'

const tree = createTree()

// split returns a new tree.
const newTree = split(tree, 0, Orientation.HORIZONTAL)
// *---------*      *---------*
// |         |      |    0    |
// |    0    |  =>  *---------*
// |         |      |    1    |
// *---------*      *---------*

const anotherTree = split(newTree, 1, Orientation.VERTICAL)
// *---------*      *---------*
// |    0    |      |    0    |
// |---------|  =>  *----*----*
// |    1    |      |  1 | 2  |
// *---------*      *----*----*
```

### remove

```typescript
declare function remove(tree: Tree, index: number): Tree;
```

`remove` will accept a [`Tree`](#tree) instance along with an `index`.

**remove** operation **deletes** new child, therefore **decreases** the
children count.

```js
import { createTree, split, remove } from 'layout-tree'

const tree = createTree()

// split returns a new tree.
const newTree = split(tree, 0, Orientation.HORIZONTAL)
// *---------*      *---------*
// |         |      |    0    |
// |    0    |  =>  *---------*
// |         |      |    1    |
// *---------*      *---------*

const anotherTree = split(newTree, 1, Orientation.VERTICAL)
// *---------*      *---------*
// |    0    |      |    0    |
// |---------|  =>  *----*----*
// |    1    |      |  1 | 2  |
// *---------*      *----*----*

const removedTree = remove(anotherTree, 1)
// *---------*      *---------*
// |    0    |      |    0    |
// *----*----*  =>  |---------|
// |  1 | 2  |      |    1    |
// *----*----*      *---------*

const beginning = remove(anotherTree, 0)
// *---------*      *---------*
// |    0    |      |         |
// *---------*  =>  |    0    |
// |    1    |      |         |
// *---------*      *---------*
```

## Reading childrens

### getAt

If you have a `tree` and you know `index`, use `getAt` to read the `child` at
that index:

```typescript
declare getAt(tree: Tree, index): Node | null;
```

### findSibling

If you know `child` and want to find one of its siblings in given
[`Direction`](#direction) use `findSibling`:

```typescript
declare findSibling(node: Node, direction: Direction): Node;
```

Let's see how these functions can be used:

```js
import { createTree, getAt, findSibling, Direction } from 'layout-tree'

const tree = createTree({ ... })
// let's imagine the above call has created the the below layout:
// *---------*---------*---------*---------*
// |         |         |         |         |
// |         |    1    |         |         |
// |         |         |         |         |
// *         *---------*         *         *
// |         |         |         |         |
// |    0    |    2    |    4    |    5    |
// |         |         |         |         |
// *         *---------*         *         *
// |         |         |         |         |
// |         |    3    |         |         |
// |         |         |         |         |
// *---------*---------*---------*---------*

// nothing fancy, just return the node at given index:
getAt(tree, 2) // => Node { meta: { id: 2 } }
getAt(tree, 5) // => Node { meta: { id: 5 } }

// if index is out of range, return null.
getAt(tree, 9) // => null

// let's first get a node, and then find its siblings:
const node = getAt(tree, 2)
// => Node { meta: { id: 2 } }
const siblingUp = findSibling(node, Direction.UP)
// => Node { meta: { id: 1 } }
const siblingLeft = findSibling(node, Direction.LEFT)
// => Node { meta: { id: 0 } }
const siblingRight = findSibling(node, Direction.RIGHT)
// => Node { meta: { id: 4 } }
const siblingDown = findSibling(node, Direction.DOWN)
// => Node { meta: { id: 3 } }
```

That's it. Check out tests to see a little bit more complicated examples.

## Inspiration

This data structure is the result of an attempt to model the beautiful layout
structure of `vim`. It's still not anywhere close to support all the features
of `vim` tabs/windows/buffers but it doesn't try to provide full api parity,
instead tries to provide a skeleton to hopefully build upon.

# install

    npm install layout-tree


# licence

MIT

