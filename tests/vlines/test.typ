#import "/src/algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 4cm, height: auto)
#algorithm(
  vstroke: .6pt + luma(200),
  {
    import algorithmic: *
    IfElseChain(
      $x < y$,
      {
        Assign[$x$][$y$]
        Assign[$z$][$t$]
      },
      For(
        $i <= 10$,
        {
          Assign[$x_i$][$i$]
          If(
            $x < y$,
            {
              Assign[$x$][$y$]
            },
          )
        },
      ),
    )
  },
)
