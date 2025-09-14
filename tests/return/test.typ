#import "../../algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 4cm, height: auto)
#algorithm({
  import algorithmic: *

  let Foo = Fn.with("foo")
  let Bar = Call.with("bar")

  Return[$x$]
  Return($x$)
  Return(Foo[$x$])
  Return(Bar[$x$])
})
