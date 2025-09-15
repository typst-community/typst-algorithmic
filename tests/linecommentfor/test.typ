#import "/src/algorithmic.typ"
#import algorithmic: *
#set page(margin: (left: .1cm, top: .1cm, bottom: .1cm), width: 11cm, height: auto)
#algorithm({
  import algorithmic: *
  LineComment(For($i <= 10$, {
    Line($1+1$)
    LineComment(While($j <= 10$, {
      Assign[$x$][1]
    }), "This is inside a nested block")
  }), "This is a line comment after a block")
})
