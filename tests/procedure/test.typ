#import "/src/algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: .1cm, width: 5cm, height: auto)
#algorithm({
  import algorithmic: *
  Procedure("Add", ($a$, $b$), { Assign($a$, $a + b$) })
})
