#import "@preview/valkyrie:0.2.2" as z
#import "@preview/oxifmt:1.0.0": strfmt

// See issue: https://github.com/typst-community/valkyrie/issues/49
#let assert-str-eq(arg) = (
  condition: (self, it) => type(it) == str and it == arg,
  message: (self, it) => "Must be exactly " + str(arg),
)

// ====== Node Schema & Construction ======

#let default-node-fields = (inline: z.boolean(default: false, optional: true))

#let node-schema = z.dictionary(
  (
    nodetype: z.string(optional: false),
    data: z.any(optional: false),
  )
    + default-node-fields,
)

#let mk-node(name, data, ..fields) = z.parse(
  (nodetype: name, data: data, ..fields.named()),
  node-schema,
)

// ====== Node Utils ======

#let is-node(node) = type(node) == dictionary and "nodetype" in node

#let is-nodetype(node, nodetype) = {
  type(node) == dictionary and "nodetype" in node and node.nodetype == nodetype
}

#let assert-nodetype(node, nodetype) = {
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

#let define-schema-set(name) = z.dictionary(
  (
    typename: z.string(optional: false, assertions: (assert-str-eq(name),)),
    constructor: z.function(optional: false),
    renderer: z.function(optional: false),
  ),
)

#let mk-schema-set(name, ctor, render) = z.parse(
  (
    typename: name,
    constructor: ctor,
    renderer: render,
  ),
  define-schema-set(name),
)

// ===========================
//     DSL Implementations
// ===========================

// ====== Line, InLine =======

#let _line-ctor = mk-node.with("Line", inline: true)
#let _line-render(node) = {
  assert-nodetype(node, "Line")
  [#node.data]
}

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

#let ctor(name) = {
  let type = _TYPES.at(name)
  type.constructor
}

// ====== Public API ======

#let render(item) = {
  (_TYPES.at(item.nodetype).renderer)(item)
}

#let Line(val) = ctor("Line")(val)
