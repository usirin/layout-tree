Tree = require './models/Tree'

module.exports = createTree = (props) -> new Tree props?.root
