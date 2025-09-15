#import "/src/algorithmic.typ"
#import algorithmic: *
#set page(margin: -.2cm, width: 4cm, height: auto)
#algorithm(
  inset: 1em, // more spacing between lines
  indent: 0.5em, // indentation for the algorithm
  {
    // provide an array
    import algorithmic: * // import all names in the array
    Assign[$x$][$y$]
  },
  {
    // provide another array
    import algorithmic: *
    Assign[$y$][$x$]
  },
  {
    // provide a third array
    import algorithmic: *
    Assign[$z$][$x + y$]
  },
)
