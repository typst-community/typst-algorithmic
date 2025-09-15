#import "@preview/tidy:0.4.3"
#import "@preview/catppuccin:1.0.0": catppuccin, flavors, show-module

#show: catppuccin.with("mocha")
#let colors = flavors.mocha.colors

#{
  set page(margin: 1em, height: auto)
  block(
    stroke: colors.overlay0.rgb + 1pt,
    inset: (x: 2cm, y: 1cm),
    radius: 5pt,
  )[
    This document is a work in progress throughout the refactoring process, which is
    happening on this branch. The final documentation will be modified to remove the
    additional styling.

    I just wanted to have this in dark mode because it makes my eyes hurty
    #emoji.face.sweat

    #align(right, [#sym.dash.two TimeTravelPenguin #emoji.penguin])
  ]
}

#show raw.where(block: true): set block(
  fill: flavors.mocha.colors.crust.rgb,
  stroke: colors.overlay0.rgb + 1pt,
  inset: (x: 2em, y: 1em),
  radius: 5pt,
)

#let docs = tidy.parse-module(
  read("/src/dsl.typ"),
  name: "DSL Module",
  old-syntax: false,
)

#show-module(
  docs,
  sort-functions: false,
  omit-private-definitions: true,
)

