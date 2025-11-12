#import "../../algorithmic.typ"
#import algorithmic: *
#set page(margin: .1cm, width: 10cm, height: auto)
text size: #context text.size
#algorithm({
  import algorithmic: *
  Assign[offset][default]
})
#pagebreak()
#set text(size: 28pt)
text size: #context text.size
#algorithm(
  horizontal-offset: 12pt,
  {
    import algorithmic: *
    Assign[offset][12pt]
  },
)
#algorithm({
  import algorithmic: *
  Assign[offset][default]
})
#pagebreak()
#set text(size: 8pt)
text size: #context text.size
#algorithm(
  horizontal-offset: 1em,
  {
    import algorithmic: *
    Assign[offset][2em]
  },
)
