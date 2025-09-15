// SPDX-FileCopyrightText: 2023 Jade Lovelace
// SPDX-FileCopyrightText: 2025 Pascal Quach
// SPDX-FileCopyrightText: 2025 Typst Community
// SPDX-FileCopyrightText: 2025 Contributors to the typst-algorithmic project
// SPDX-License-Identifier: MIT

#import "dsl.typ": (
  Assign, Break, Call, CallInline, Comment, CommentInline, Else, ElseIf, Fn,
  FnInline, For, Function, If, IfElseChain, Line, LineBreak, LineComment,
  Procedure, Return, Terminate, While,
)

/*
 * Generated AST:
 * (change-indent: int, body: ((ast | content)[] | content | ast)
 */

#let ast-to-content-list(indent, ast) = {
  if type(ast) == array {
    // array of (ast | content)
    ast.map(d => ast-to-content-list(indent, d))
  } else if type(ast) == content {
    // (line-content: ast, line-indent: int)
    (line-content: ast, line-indent: indent)
  } else if type(ast) == dictionary {
    // (change-indent: int, body: ((ast | content)[] | content | ast))
    let new-indent = ast.at("change-indent", default: 0) + indent
    ast-to-content-list(new-indent, ast.body)
  }
}

#let style-algorithm(
  body,
  caption-style: strong,
  caption-align: start,
  breakable: true,
  hlines: (grid.hline(), grid.hline(), grid.hline()),
  placement: none,
  scope: "column",
) = {
  show figure.where(kind: "algorithm"): it => {
    set block(breakable: breakable)
    let algo = grid(
      columns: 1,
      stroke: none,
      inset: 0% + 5pt,
      hlines.at(0),
      caption-style(align(caption-align, it.caption)),
      hlines.at(1),
      align(start, it.body),
      hlines.at(2),
    )
    let _placement = placement
    let _scope = scope
    if it.placement != none { _placement = it.placement }
    if it.scope != "column" { _scope = it.scope }
    if _placement != none {
      place(_placement, scope: _scope, float: true, algo)
    } else {
      algo
    }
  }
  body
}

#let algorithm(
  inset: 0.2em,
  indent: 0.5em,
  vstroke: 0pt + luma(200),
  line-numbers: true,
  ..bits,
) = {
  let content = bits.pos().map(b => ast-to-content-list(0, b)).flatten()
  if content.len() == 0 or content == (none,) {
    return none
  }
  let grid-bits = ()
  let line-number = 1

  let indent-list = content.map(c => c.line-indent)
  let max-indent = indent-list.sorted().last()
  let colspans = indent-list.map(i => max-indent + 1 - i)
  let indent-content = indent-list.map(i => (
    ([], grid.vline(stroke: vstroke), []) * int(i / 2)
  ))
  let indents = (indent,) * max-indent
  let offset = 18pt + if indents.len() != 0 { indents.sum() }
  let columns = (..indents, 100% - offset)
  if line-numbers {
    columns.insert(0, 18pt)
  }

  while line-number <= content.len() {
    if line-numbers { grid-bits.push([#line-number:]) }
    grid-bits = grid-bits + indent-content.at(line-number - 1)
    grid-bits.push(grid.cell(
      content.at(line-number - 1).line-content,
      colspan: colspans.at(line-number - 1),
    ))
    line-number = line-number + 1
  }
  return grid(
    columns: columns,
    // line spacing
    inset: inset,
    stroke: none,
    ..grid-bits
  )
}

#let algorithm-figure(
  title,
  supplement: "Algorithm",
  inset: 0.2em,
  indent: 0.5em,
  vstroke: 0pt + luma(200),
  line-numbers: true,
  ..bits,
) = {
  return figure(
    supplement: supplement,
    kind: "algorithm",
    caption: title,
    algorithm(
      indent: indent,
      inset: inset,
      vstroke: vstroke,
      line-numbers: line-numbers,
      ..bits,
    ),
  )
}

