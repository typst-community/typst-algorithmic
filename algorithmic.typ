// SPDX-FileCopyrightText: 2023 Jade Lovelace
//
// SPDX-License-Identifier: MIT

/*
 * Generated AST:
 * (change_indent: int, body: ((ast | content)[] | content | ast)
 */

#let ast_to_content_list(indent, ast) = {
  if type(ast) == array {
    ast.map(d => ast_to_content_list(indent, d))
  } else if type(ast) == content {
    (pad(left: indent * 0.5em, ast),)
  } else if type(ast) == dictionary {
    let new_indent = ast.at("change_indent", default: 0) + indent
    ast_to_content_list(new_indent, ast.body)
  }
}

#let algorithm(title, supplement: "Algorithm", ..bits) = {
  let content = bits.pos().map(b => ast_to_content_list(0, b)).flatten()
  let table_bits = ()
  let lineno = 1

  while lineno <= content.len() {
    table_bits.push([#lineno:])
    table_bits.push(content.at(lineno - 1))
    lineno = lineno + 1
  }
  show figure.where(kind: "algorithm"): it => {
    set align(left)
    table(
      columns: 1,
      stroke: none,
      table.hline(),
      strong(it.caption),
      table.hline(),
      it.body,
      table.hline(),
    )
  }
  figure(
    supplement: supplement,
    kind: "algorithm",
    caption: title,
    placement: none,
    table(
      columns: (18pt, 100%),
      // line spacing
      inset: 0.4em,
      stroke: none,
      ..table_bits
    ),
  )
}

#let iflike_block(kw1: "", kw2: "", kw3: "", cond: "", ..body) = (
  (strong(kw1) + " " + cond + " " + strong(kw2)),
  // XXX: .pos annoys me here
  (change_indent: 4, body: body.pos()),
  strong(kw3),
)

#let arraify(v) = {
  if type(v) == array {
    v
  } else {
    (v,)
  }
}
#let function_like(name, kw: "function", args: (), ..body) = (
  iflike_block(kw1: kw, kw3: "end", cond: (smallcaps(name) + $(#arraify(args).join(", "))$), ..body)
)

#let Function = function_like.with(kw: "function")
#let Procedure = function_like.with(kw: "procedure")

#let State(block) = ((body: block),)

/// Inline call
#let CallI(name, args) = [#smallcaps(name)$(#arraify(args).join(", "))$]
#let Call(..args) = (CallI(..args),)
#let FnI(f, args) = [#strong(f)$(#arraify(args).join(", "))$]
#let Fn(..args) = (FnI(..args),)
#let Ic(c) = sym.triangle.stroked.r + " " + c
#let Cmt(c) = (Ic(c),)
// It kind of sucks that Else is a separate block but it's fine
#let If = iflike_block.with(kw1: "if", kw2: "then", kw3: "end")
#let While = iflike_block.with(kw1: "while", kw2: "do", kw3: "end")
#let For = iflike_block.with(kw1: "for", kw2: "do", kw3: "end")
#let Assign(var, val) = (var + " " + $<-$ + " " + val,)

#let Else = iflike_block.with(kw1: "else", kw3: "end")
#let ElsIf = iflike_block.with(kw1: "else if", kw2: "then", kw3: "end")
#let ElseIf = ElsIf
#let Return(arg) = (strong("return") + " " + arg,)
