#import "@preview/valkyrie:0.2.2" as z
#import "@preview/oxifmt:1.0.0": strfmt

/// A Valkyrie assertion to check for exact string equality.
/// See issue: https://github.com/typst-community/valkyrie/issues/49
#let _assert-str-eq(arg) = (
  condition: (self, it) => type(it) == str and it == arg,
  message: (self, it) => "Must be exactly " + str(arg),
)


// ====== Node Schema & Construction ======

/// Default schema fields for all nodes.
///
/// It has the following definition:
///  ```typc
///  import "@preview/valkyrie:0.2.2" as z
///
///  let default-node-fields = (
///     inline: z.boolean(default: false, optional: true),
///  )
///  ```
/// -> dictionary
#let default-node-fields = (inline: z.boolean(default: false, optional: true))


/// Schema for nodes. Nodes encapsulate all data for a given AST item.
///
/// It has the following definition:
/// ```typc
/// import "@preview/valkyrie:0.2.2" as z
///
/// let node-schema = z.dictionary(
///   (
///     nodetype: z.string(optional: false),
///     data: z.any(optional: false),
///   )
///     + default-node-fields,
/// )
/// ```
/// See @default-node-fields for additional fields.
/// -> dictionary
#let node-schema = z.dictionary(
  (
    nodetype: z.string(optional: false),
    data: z.any(optional: false),
  )
    + default-node-fields,
)


/// Construct a node of a given type with data and optional fields.
/// -> dictionary
#let mk-node(
  /// The type of node to create. -> str
  name,
  /// The data to store in the node. -> any
  data,
  /// Additional fields to store in the node. -> dictionary
  ..fields,
) = z.parse(
  (nodetype: name, data: data, ..fields.named()),
  node-schema,
)


// ====== Node Utils ======

/// Check if a value is a node.
/// -> boolean
#let is-node(
  /// The value to check. -> any
  node,
) = type(node) == dictionary and "nodetype" in node


/// Check if a node is of a given type.
/// -> boolean
#let is-nodetype(
  /// The node to check. -> any
  node,
  /// The expected node type. -> str
  nodetype,
) = {
  type(node) == dictionary and "nodetype" in node and node.nodetype == nodetype
}


/// Assert that a value is a node of a given type.
#let assert-nodetype(
  /// The value to check. -> any
  node,
  /// The expected node type. -> str
  nodetype,
) = {
  assert(is-node(node), message: strfmt(
    "Expected a node. Got: {}.",
    repr(node),
  ))

  assert(is-nodetype(node, nodetype), message: strfmt(
    "Invalid nodetype. Expected: '{}'. Got: '{}'.",
    type,
    node.nodetype,
  ))
}


// ====== Schema Set ======

/// Define a schema set for a given node type.
///
/// A schema serves as a blueprint for creating and rendering nodes of that type.
///
/// A schema set includes:
/// - *typename*: The name of the node type.
/// - *constructor*: A function to create nodes of this type.
/// - *renderer*: A function to render nodes of this type.
/// -> dictionary
#let declare-schema-set(
  /// The name of the node type. -> str
  name,
) = z.dictionary(
  (
    typename: z.string(optional: false, assertions: (_assert-str-eq(name),)),
    constructor: z.function(optional: false),
    renderer: z.function(optional: false),
  ),
)


/// Create a schema set for a given node type.
/// -> dictionary
#let mk-schema-set(
  /// The name of the node type. -> str
  name,
  /// The constructor function for the node type. -> function
  ctor,
  /// The renderer function for the node type. -> function
  render,
) = z.parse(
  (
    typename: name,
    constructor: ctor,
    renderer: render,
  ),
  declare-schema-set(name),
)


// ===========================
//     DSL Implementations
// ===========================

// ====== Line, InLine =======

/// A constructor for a Line node.
/// A Line represents a single line of content in the DSL.
/// -> function
#let _line-ctor(
  /// The content of the line. -> any
  data,
  /// Additional fields for the node. Refer to @default-node-fields. -> arguments
  ..fields,
) = mk-node("Line", data, inline: false, ..fields)


/// A renderer for a Line node.
/// Renders the content of the line.
/// -> content
#let _line-render(node) = {
  assert-nodetype(node, "Line")
  [#node.data]
}


/// Schema for Line nodes. -> dictionary
#let _line-schema = mk-schema-set("Line", _line-ctor, _line-render)

// TODO: Remaining items
// Control flow:
//   If
//   ElseIf
//   Else
//   While
//   For
//   IfElseChain
// Commands:
//   Function
//   Procedure
//   Assign
//   Return
//   Terminate
//   Break
//   Call
//   Fn
//   CallInline
//   FnInline
// NEW:
// 	 Continue
// 	 Yield
// Commnts:
//   Comment
//   CommentInline
//   LineComment

// ====== DSL Type Registration ======

/// Registry of all defined node types.
/// Maps node type names to their corresponding schema sets.
/// -> dictionary
#let _TYPES = {
  let registry = (:)

  let register(reg, tag, f) = {
    reg.insert(tag, f)
    reg
  }

  let schemas = (
    Line: _line-schema,
  )

  schemas.pairs().fold((:), (reg, r) => register(reg, ..r))
}


/// Retrieve the constructor function for a given node type.
/// -> function
#let ctor(
  /// The name of the node type. -> str
  name,
) = {
  _TYPES.at(name).constructor
}


// ====== Public API ======

/// Render a node based on its type using the appropriate renderer.
/// -> content
#let render(
  /// The node to render. -> dictionary
  item,
) = (_TYPES.at(item.nodetype).renderer)(item)


/// Construct a Line node.
/// -> dictionary
#let Line(
  /// The content of the line. -> any
  val,
  /// Additional fields for the node.
  /// Refer to @default-node-fields.
  /// -> arguments
  ..args,
) = ctor("Line")(val, ..args)
