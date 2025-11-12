#import "../../algorithmic.typ"
#import algorithmic: *
#set page(margin: .1cm, width: 10cm, height: auto)
#algorithm(line-numbers: true, {
  import algorithmic: *
  for i in range(1, 5) {
    Assign($x$, str(i))
  }
})
#algorithm(line-numbers: false, {
  import algorithmic: *
  for i in range(1, 5) {
    Assign($y$, str(i))
  }
})
#algorithm(
  line-numbers: num => str(num) + "|",
  {
    import algorithmic: *
    for i in range(1, 5) {
      Assign($y$, str(i))
    }
  },
)

#show: style-algorithm
#let algorithm = algorithm.with(line-numbers: false)
#let algorithm-figure = algorithm-figure.with(line-numbers: false)
#algorithm-figure(
  "Binary Search",
  indent: 2em,
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

#algorithm-figure(
  "Binary Search",
  line-numbers: true, // Override global setting
  indent: 2em,
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
