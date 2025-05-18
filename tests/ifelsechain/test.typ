#import "../../algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 4cm, height: auto)
#algorithm({
  import algorithmic: *
  IfElseChain(
    // Alternating content and bits
    $x < y$, // If: content 1 (condition)
    {
      // Then: bits 1
      Assign[$x$][$y$]
    },
    [$x > y$], // ElseIf: content 2 (condition)
    {
      // Then: bits 2
      Assign[$y$][$x$]
    },
    Return[$y$], // Else: content 3 (no more bits afterwards)
  )
})
