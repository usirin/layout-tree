ParentNode = require './models/ParentNode'

module.exports = createParentNode = ({ orientation, children, meta }) ->
  parent = new ParentNode meta, orientation
  parent.attachChildren children

  return parent
