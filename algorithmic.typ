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
#let style-algorithm = it => {
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
  it
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
#let iflike_block(kw1: "", kw2: "", kw3: "", cond, ..body) = (
  (strong(kw1) + " " + cond + " " + strong(kw2)),
  (change_indent: 4, body: body.pos()),
  strong(kw3),
)
#let iflike_block_with_kw3(kw1: "", kw2: "", kw3: "", cond, ..body) = (
  (strong(kw1) + " " + cond + " " + strong(kw2)),
  (change_indent: 4, body: body.pos()),
  strong(kw3),
)
#let iflike_block_without_kw3(kw1: "", kw2: "", cond, ..body) = (
  (strong(kw1) + " " + cond + " " + strong(kw2)),
  (change_indent: 4, body: body.pos()),
)
#let iflike_block(kw1: "", kw2: "", kw3: none, cond, ..body) = (
  if kw3 == "" or kw3 == none {
    iflike_block_without_kw3(kw1: kw1, kw2: kw2, cond, ..body)
  } else {
    iflike_block_with_kw3(kw1: kw1, kw2: kw2, kw3: kw3, cond, ..body)
  }
)
#let arraify(v) = {
  if type(v) == array {
    v
  } else {
    (v,)
  }
}
#let call(name, kw: "function", inline: false, style: smallcaps, args, ..body) = (
  if inline {
    [#style(name)\(#arraify(args).join(", ")\)]
  } else {
    iflike_block(kw1: kw, kw3: "end", (style(name) + $(#arraify(args).join(", "))$), ..body)
  }
)

// Named blocks
#let Function = call.with(kw: "function")
#let Procedure = call.with(kw: "procedure")

// Misc
#let State(block) = ((body: block),)
#let LineBreak = State[]

/// Inline call
#let CallInline(name, args) = call(inline: true, name, args)
#let FnInline(f, args) = call(inline: true, style: strong, f, args)
#let CommentInline(c) = sym.triangle.stroked.r + " " + c

// Block calls
#let Call(..args) = (CallInline(..args),)
#let Fn(..args) = (FnInline(..args),)
#let Comment(c) = (CommentInline(c),)
#let LineComment(l, c) = ([#l.first()#h(1fr)#CommentInline(c)],)

// Control flow
#let If = iflike_block.with(kw1: "if", kw2: "then", kw3: "end")
#let While = iflike_block.with(kw1: "while", kw2: "do", kw3: "end")
#let For = iflike_block.with(kw1: "for", kw2: "do", kw3: "end")
#let Else = iflike_block.with(kw1: "else", kw2: "", kw3: "end", "")
#let ElseIf = iflike_block.with(kw1: "else if", kw2: "then", kw3: "end")
#let IfElseChain(..conditions_and_bodies) = {
  let result = ()
  let conditions_and_bodies = conditions_and_bodies.pos()
  let len = conditions_and_bodies.len()
  let i = 0

  while i < len {
    if i == len - 1 and calc.odd(len) {
      // Last element is the "else" block
      result.push(Else(..arraify(conditions_and_bodies.at(i))))
    } else if calc.even(i) {
      // Condition
      let cond = conditions_and_bodies.at(i)
      let body = arraify(conditions_and_bodies.at(i + 1))
      if i + 2 == len {
        // No "else" or "else if" after this
        result.push(If(cond, ..body, kw3: "end"))
      } else {
        result.push(If(cond, ..body, kw3: ""))
      }
    } else {
      // Skip body since it's already processed
    }
    i = i + 1
  }
  result
}

// Instructions
#let Assign(var, val) = (var + " " + $<-$ + " " + val,)
#let Return(arg) = (strong("return") + " " + arg,)
#let Terminate = (smallcaps("terminate"),)
