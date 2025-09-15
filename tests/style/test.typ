#import "/src/algorithmic.typ"
#import algorithmic: *
#set page(margin: .1cm, width: 10cm, height: auto)
#show: style-algorithm
#algorithm-figure(
  "Binary Search",
  {
    import algorithmic: *
    Procedure(
      "Binary-Search",
      ("A", "n", "v"),
      {
        Comment[Initialize the search range]
        Assign[$l$][$1$]
        Assign[$r$][$n$]
        LineBreak
        While(
          $l <= r$,
          {
            Assign([mid], FnInline[floor][$(l + r) / 2$])
            IfElseChain(
              $A ["mid"] < v$,
              {
                Assign[$l$][$m + 1$]
              },
              [$A ["mid"] > v$],
              {
                Assign[$r$][$m - 1$]
              },
              Return[$m$],
            )
          },
        )
        Return[*null*]
      },
    )
  },
)
