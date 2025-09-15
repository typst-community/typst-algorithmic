#import "/src/algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 4cm, height: auto)
#algorithm({
  import algorithmic: *
  For(
    $i <= 10$,
    {
      Assign[$x_i$][$i$]
    },
  )
})

