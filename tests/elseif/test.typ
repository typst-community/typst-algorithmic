#import "/src/algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 4cm, height: auto)
#algorithm({
  import algorithmic: *
  ElseIf(
    $x > y$,
    {
      Assign[$y$][$x$]
    },
  )
})

