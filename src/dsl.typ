#let iflike-unterminated(kw1: "", kw2: "", cond, ..body) = (
  (strong(kw1) + " " + cond + " " + strong(kw2)),
  (change-indent: 2, body: body.pos()),
)
#let iflike-terminated(kw1: "", kw2: "", kw3: "", cond, ..body) = (
  (strong(kw1) + " " + cond + " " + strong(kw2)),
  (change-indent: 2, body: body.pos()),
  strong(kw3),
)
#let iflike(kw1: "", kw2: "", kw3: none, cond, ..body) = (
  if kw3 == "" or kw3 == none {
    iflike-unterminated(kw1: kw1, kw2: kw2, cond, ..body)
  } else {
    iflike-terminated(kw1: kw1, kw2: kw2, kw3: kw3, cond, ..body)
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
    iflike(kw1: kw, kw3: "end", (style(name) + $(#arraify(args).join(", "))$), ..body)
  }
)

// Named blocks
#let Function = call.with(kw: "function")
#let Procedure = call.with(kw: "procedure")

// Misc
#let Line(block) = (block,)
#let LineBreak = Line[]

/// Inline call
#let CallInline(name, args) = call(inline: true, name, args)
#let FnInline(f, args) = call(inline: true, style: strong, f, args)
#let CommentInline(c) = sym.triangle.stroked.r + " " + c

// Block calls
#let Call(..args) = (CallInline(..args),)
#let Fn(..args) = (FnInline(..args),)
#let Comment(c) = (CommentInline(c),)
#let LineComment(l, c) = ([#l.first()#h(1fr)#CommentInline(c)], ..l.slice(1))

// Control flow
#let If = iflike.with(kw1: "if", kw2: "then", kw3: "end")
#let While = iflike.with(kw1: "while", kw2: "do", kw3: "end")
#let For = iflike.with(kw1: "for", kw2: "do", kw3: "end")
#let Else = iflike.with(kw1: "else", kw2: "", kw3: "end", "")
#let ElseIf = iflike.with(kw1: "else if", kw2: "then", kw3: "end")
#let IfElseChain(..conditions-and-bodies) = {
  let result = ()
  let conditions-and-bodies = conditions-and-bodies.pos()
  let len = conditions-and-bodies.len()
  let i = 0

  while i < len {
    if i == len - 1 and calc.odd(len) {
      // Last element is the "else" block
      result.push(Else(..arraify(conditions-and-bodies.at(i))))
    } else if calc.even(i) {
      // Condition
      let cond = conditions-and-bodies.at(i)
      let body = arraify(conditions-and-bodies.at(i + 1))
      if i == 0 {
        // First condition is a regular "if"
        result.push(If(cond, ..body, kw3: ""))
      } else if i + 2 == len {
        // Last condition before "else" is an "elseif" with "end"
        result.push(ElseIf(cond, ..body, kw3: "end"))
      } else {
        // Intermediate conditions are "elseif" without "end"
        result.push(ElseIf(cond, ..body, kw3: ""))
      }
    } else {
      // Skip body since it's already processed
    }
    i = i + 1
  }
  result
}

// Instructions
#let Assign(var, val) = (var + " " + $<-$ + " " + arraify(val).join(", "),)
#let Return(arg) = (strong("return") + " " + arraify(arg).join(", "),)
#let Terminate = (smallcaps("terminate"),)
#let Break = (smallcaps("break"),)
