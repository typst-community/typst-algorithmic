#import "../../algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 4cm, height: auto)
#algorithm({
  import algorithmic: *
  While(
    $i < 10$,
    {
      Assign[$i$][$i + 1$]
    },
  )
})

