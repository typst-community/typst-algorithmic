#import "../../algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 5cm, height: auto)
#algorithm({
  import algorithmic: *
  Assign($m$, IfElseInline($x < y$, $x$, $y$))
})
