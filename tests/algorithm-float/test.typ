#import "../../algorithmic.typ"
#import algorithmic: *
#set page(paper: "a6")
#show: style-algorithm.with(breakable: false)
#let fig(title) = algorithm-figure(
  title,
  {
    import algorithmic: *
    Procedure(
      "Procedure",
      (),
      {
        for i in range(1) { Assign[a][b] }
      },
    )
  },
)

#[
  #show figure.where(kind: "algorithm"): set figure(placement: bottom)
  #fig("placement: bottom")
]
#pagebreak()
#[
  #show figure.where(kind: "algorithm"): set figure(placement: top)
  #fig("placement: top")
]
#pagebreak()
#[
  #show figure.where(kind: "algorithm"): set figure(placement: auto)
  #fig("placement: auto (top)")
]
#pagebreak()
#[
  #lorem(60)
  #show figure.where(kind: "algorithm"): set figure(placement: auto)
  #fig("placement: auto (bottom)")
]
#pagebreak()
#[
  #columns(2)[
    #lorem(1)
    #show figure.where(kind: "algorithm"): set figure(placement: auto)
    #fig("placement: auto (top), scope: column")
  ]
]
#pagebreak()
#[
  #columns(2)[
    #lorem(60)
    #show figure.where(kind: "algorithm"): set figure(placement: auto, scope: "parent")
    #fig("placement: auto (bottom), scope: parent")
  ]
]
#pagebreak()
#[
  #show: style-algorithm.with(breakable: true, placement: bottom, scope: "column")
  #fig("style-algorithm with breakable: true, placement: bottom, scope: column")
]

#pagebreak()
#context query(figure.where(kind: "algorithm")).map(it => (it.placement, it.scope))
