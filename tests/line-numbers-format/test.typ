#import "../../algorithmic.typ"
#import algorithmic: *
#set page(margin: .1cm, width: 10cm, height: auto)

#algorithm(
  line-numbers-format: num => str(num) + "|",
  {
    import algorithmic: *
    for i in range(1, 5) {
      Assign($y$, str(i))
    }
  },
)
