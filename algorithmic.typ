// SPDX-FileCopyrightText: 2023 Jade Lovelace
// SPDX-FileCopyrightText: 2025 Pascal Quach
// SPDX-FileCopyrightText: 2025 Typst Community
// SPDX-FileCopyrightText: 2025 Contributors to the typst-algorithmic project
// SPDX-License-Identifier: MIT

/*
 * Generated AST:
 * (change_indent: int, body: ((ast | content)[] | content | ast)
 */

#import "locale.typ": locale

#let localize(kw, lang: "en") = {
  if type(kw) == str {
    let kws = locale.at(lang)
    kws.at(kw, default: kw)
  } else if type(kw) == dictionary {
    kw.at(lang, default:
      kw.at("en", default:
        kw.values().at(0, default:
          none
        )
      )
    )
  } else {
    kw
  }
}

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
  show figure: set block(breakable: true)
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
#let algorithm(inset: 0.2em, ..bits) = {
  let content = bits.pos().map(b => ast_to_content_list(0, b)).flatten()
  let table_bits = ()
  let lineno = 1

  while lineno <= content.len() {
    table_bits.push([#lineno:])
    table_bits.push(content.at(lineno - 1))
    lineno = lineno + 1
  }
  return table(
    columns: (18pt, 100%),
    // line spacing
    inset: inset,
    stroke: none,
    ..table_bits
  )
}
#let algorithm-figure(title, supplement: none, inset: 0.2em, lang: "en", ..bits) = {
  return figure(
    supplement: if supplement == none {
      localize("Algorithm", lang: lang)
    } else {
      supplement
    },
    kind: "algorithm",
    caption: title,
    placement: none,
    algorithm(inset: inset, ..bits),
  )
}
#let iflike_block(kw1: "", kw2: "", kw3: "", lang: "en", cond, ..body) = (
  (strong(localize(kw1, lang: lang)) + " " + cond + " " + strong(localize(kw2, lang: lang))),
  (change_indent: 2, body: body.pos()),
  strong(localize(kw3, lang: lang)),
)
#let iflike_block_with_kw3(kw1: "", kw2: "", kw3: "", lang: "en", cond, ..body) = (
  (strong(localize(kw1, lang: lang)) + " " + cond + " " + strong(localize(kw2, lang: lang))),
  (change_indent: 2, body: body.pos()),
  strong(localize(kw3, lang: lang)),
)
#let iflike_block_without_kw3(kw1: "", kw2: "", lang: "en", cond, ..body) = (
  (strong(localize(kw1, lang: lang)) + " " + cond + " " + strong(localize(kw2, lang: lang))),
  (change_indent: 2, body: body.pos()),
)
#let iflike_block(kw1: "", kw2: "", kw3: none, lang: "en", cond, ..body) = (
  if kw3 == "" or kw3 == none {
    iflike_block_without_kw3(kw1: kw1, kw2: kw2, lang: lang, cond, ..body)
  } else {
    iflike_block_with_kw3(kw1: kw1, kw2: kw2, kw3: kw3, lang: lang, cond, ..body)
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
    iflike_block(kw1: kw, kw3: "end", (style(localize(name, lang: lang)) + $(#arraify(args).join(", "))$), lang: lang, ..body)
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
#let If = iflike_block.with(kw1: "if", kw2: "then", kw3: "end")
#let While = iflike_block.with(kw1: "while", kw2: "do", kw3: "end")
#let For = iflike_block.with(kw1: "for", kw2: "do", kw3: "end")
#let Else = iflike_block.with(kw1: "else", kw2: "", kw3: "end", "")
#let ElseIf = iflike_block.with(kw1: "else if", kw2: "then", kw3: "end")
#let IfElseChain(lang: none, ..conditions_and_bodies) = {
  let result = ()
  let conditions_and_bodies = conditions_and_bodies.pos()
  let len = conditions_and_bodies.len()
  let i = 0

  while i < len {
    if i == len - 1 and calc.odd(len) {
      // Last element is the "else" block
      result.push(Else(..arraify(conditions_and_bodies.at(i)), lang: lang))
    } else if calc.even(i) {
      // Condition
      let cond = conditions_and_bodies.at(i)
      let body = arraify(conditions_and_bodies.at(i + 1))
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
