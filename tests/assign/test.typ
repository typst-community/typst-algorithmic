#import "/src/algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 4cm, height: auto)
#algorithm({
  import algorithmic: *

  let Foo = Fn.with("foo")
  let Bar = Call.with("bar")

  Assign[$x$][$y$]
  Assign($x$, $y$)
  Assign($x$, Foo[$y$, $z$])
  Assign($x$, Foo[$y$])
  Assign($x$, Bar[$y$])
  Assign($x$, Bar[$y$, $z$])
})
