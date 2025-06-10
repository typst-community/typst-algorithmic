// SPDX-FileCopyrightText: 2023 Jade Lovelace
// SPDX-FileCopyrightText: 2025 Pascal Quach
// SPDX-FileCopyrightText: 2025 Typst Community
// SPDX-FileCopyrightText: 2025 Contributors to the typst-algorithmic project
// SPDX-License-Identifier: MIT

/*
 * Generated AST:
 * (change-indent: int, body: ((ast | content)[] | content | ast)
 */

#import "locale.typ": locale

#let localize(kw, lang: "en") = {
  if type(kw) == str {
    let kws = locale.at(lang)
    kws.at(kw, default: kw)
  } else if type(kw) == dictionary {
    kw.at(lang, default: kw.at("en", default: kw.values().at(0, default: none)))
  } else {
    kw
  }
}

#let ast_to_content_list(indent, ast) = {
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
  it,
  caption-style: strong,
  caption-align: start,
  breakable: true,
  hlines: (table.hline(), table.hline(), table.hline()),
) = {
  show figure.where(kind: "algorithm"): it => {
    set block(breakable: breakable)
    table(
      columns: 1,
      stroke: none,
      hlines.at(0),
      caption-style(align(caption-align, it.caption)),
      hlines.at(1),
      align(start, it.body),
      hlines.at(2),
    )
  }
  it
}

#let algorithm(inset: 0.2em, indent: 0.5em, vstroke: 0pt + luma(200), ..bits) = {
  let content = bits.pos().map(b => ast-to-content-list(0, b)).flatten()
  if content.len() == 0 or content == (none,) {
    return none
  }
  let table-bits = ()
  let line-number = 1

  let indent-list = content.map(c => c.line-indent)
  let max-indent = indent-list.sorted().last()
  let colspans = indent-list.map(i => max-indent + 1 - i)
  let indent-content = indent-list.map(i => ([], table.vline(stroke: vstroke), []) * int(i / 2))
  let columns = (18pt, ..(indent,) * max-indent, 100%)

  while line-number <= content.len() {
    table-bits.push([#line-number:])
    table-bits = table-bits + indent-content.at(line-number - 1)
    table-bits.push(table.cell(content.at(line-number - 1).line-content, colspan: colspans.at(line-number - 1)))
    line-number = line-number + 1
  }
  return table(
    columns: columns,
    // line spacing
    inset: inset,
    stroke: none,
    ..table-bits
  )
}
#let algorithm-figure(
  title,
  supplement: none,
  inset: 0.2em,
  indent: 0.5em,
  vstroke: 0pt + luma(200),
  lang: "en",
  ..bits,
) = {
  return figure(
    supplement: if supplement == none {
      localize("Algorithm", lang: lang)
    } else {
      supplement
    },
    kind: "algorithm",
    caption: title,
    placement: none,
    algorithm(indent: indent, inset: inset, vstroke: vstroke, ..bits),
  )
}

#let iflike-unterminated(kw1: "", kw2: "", cond, lang: "en", ..body) = (
  (strong(localize(kw1, lang: lang)) + " " + cond + " " + strong(localize(kw2, lang: lang))),
  (change-indent: 2, body: body.pos()),
)
#let iflike-terminated(kw1: "", kw2: "", kw3: "", cond, lang: "en", ..body) = (
  (strong(localize(kw1, lang: lang)) + " " + cond + " " + strong(localize(kw2, lang: lang))),
  (change-indent: 2, body: body.pos()),
  strong(localize(kw3, lang: lang)),
)
#let iflike(kw1: "", kw2: "", kw3: none, cond, lang: "en", ..body) = (
  if kw3 == "" or kw3 == none {
    iflike-unterminated(kw1: kw1, kw2: kw2, cond, lang: lang, ..body)
  } else {
    iflike-terminated(kw1: kw1, kw2: kw2, kw3: kw3, cond, lang: lang, ..body)
  }
)
#let arraify(v) = {
  if type(v) == array {
    v
  } else {
    (v,)
  }
}
#let call(name, kw: "function", inline: false, style: smallcaps, lang: "en", args, ..body) = (
  if inline {
    [#style(localize(name, lang: lang))\(#arraify(args).join(", ")\)]
  } else {
    iflike(kw1: kw, kw3: "end", (style(name) + $(#arraify(args).join(", "))$), lang: lang, ..body)
  }
)

// Named blocks
#let Function = call.with(kw: "function")
#let Procedure = call.with(kw: "procedure")

// Misc
#let State(block) = ((body: block),)
#let LineBreak = State[]

/// Inline call
#let CallInline(name, args, lang: none) = call(inline: true, name, args, lang: lang)
#let FnInline(f, args, lang: none) = call(inline: true, style: strong, f, args, lang: lang)
#let CommentInline(c) = sym.triangle.stroked.r + " " + c

// Block calls
#let Call(lang: none, ..args) = (CallInline(..args, lang: lang),)
#let Fn(lang: none, ..args) = (FnInline(..args, lang: lang),)
#let Comment(c) = (CommentInline(c),)
#let LineComment(l, c) = ([#l.first()#h(1fr)#CommentInline(c)],)

// Control flow
#let If = iflike.with(kw1: "if", kw2: "then", kw3: "end")
#let While = iflike.with(kw1: "while", kw2: "do", kw3: "end")
#let For = iflike.with(kw1: "for", kw2: "do", kw3: "end")
#let Else = iflike.with(kw1: "else", kw2: "", kw3: "end", "")
#let ElseIf = iflike.with(kw1: "else if", kw2: "then", kw3: "end")
#let IfElseChain(lang: "en", ..conditions-and-bodies) = {
  let result = ()
  let conditions-and-bodies = conditions-and-bodies.pos()
  let len = conditions-and-bodies.len()
  let i = 0

  while i < len {
    if i == len - 1 and calc.odd(len) {
      // Last element is the "else" block
      result.push(Else(..arraify(conditions-and-bodies.at(i)), lang: lang))
    } else if calc.even(i) {
      // Condition
      let cond = conditions-and-bodies.at(i)
      let body = arraify(conditions-and-bodies.at(i + 1))
      if i == 0 {
        // First condition is a regular "if"
        result.push(If(cond, ..body, kw3: "", lang: lang))
      } else if i + 2 == len {
        // Last condition before "else" is an "elseif" with "end"
        result.push(ElseIf(cond, ..body, kw3: "end", lang: lang))
      } else {
        // Intermediate conditions are "elseif" without "end"
        result.push(ElseIf(cond, ..body, kw3: "", lang: lang))
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
#let Return(arg, lang: "en") = (strong(localize("return", lang: lang)) + " " + arg,)
#let Terminate(lang: "en") = (smallcaps(localize("terminate", lang: lang)),)
#let Break(lang: "en") = (smallcaps(localize("break", lang: lang)),)
