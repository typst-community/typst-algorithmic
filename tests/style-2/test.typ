#import "../../algorithmic.typ"
#import algorithmic: *
#set page(margin: .1cm, width: 10cm, height: auto)
#show: style-algorithm.with(
  breakable: false,
  caption-align: end,
  caption-style: emph,
  hlines: (grid.hline(stroke: 2pt + red), grid.hline(stroke: 2pt + blue), grid.hline(stroke: 2pt + green)),
)
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
