#import "/src/algorithmic.typ"
#import algorithmic: *
#set page(paper: "a4", height: auto)
#algorithm({
  import algorithmic: *
  If($x+1 = 1$, {
    LineComment(Line($1+1$), "This is a single line comment")
    LineComment(Assign[$x$][1], "Ipsum")
  })
})

#line(length: 100%)
