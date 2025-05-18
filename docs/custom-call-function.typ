#import "../algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 4cm, height: auto)
#algorithm({
  import algorithmic: *
  let Solve = CallInline.with("Solve")
  let mean = FnInline.with("mean")
  Assign($x$, Solve[$A$, $b$])
  Assign($y$, mean[$x$])
})
