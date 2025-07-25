// SPDX-FileCopyrightText: 2023 Jade Lovelace
// SPDX-FileCopyrightText: 2025 Pascal Quach
// SPDX-FileCopyrightText: 2025 Typst Community
// SPDX-FileCopyrightText: 2025 Contributors to the typst-algorithmic project
// SPDX-License-Identifier: MIT
#set page(height: auto)
#import "../algorithmic.typ"
#import algorithmic: algorithm, algorithm-figure, style-algorithm
#show: style-algorithm
#algorithm-figure(
  "Binary Search",
  vstroke: .5pt + luma(200),
  {
    import algorithmic: *
    Procedure(
      "Binary-Search",
      ("A", "n", "v"),
      {
        Comment[Initialize the search range]
        Assign[$l$][$1$]
        Assign[$r$][$n$]
        LineBreak
        While(
          $l <= r$,
          {
            Assign([mid], FnInline[floor][$(l + r) / 2$])
            IfElseChain(
              $A ["mid"] < v$,
              {
                Assign[$l$][$"mid" + 1$]
              },
              [$A ["mid"] > v$],
              {
                Assign[$r$][$"mid" - 1$]
              },
              Return[mid],
            )
          },
        )
        Return[*null*]
      },
    )
  },
) <algo:binary-search>

@algo:binary-search describes the pseudo-code for the binary search algorithm.

#quote(
  block: true,
  attribution: [Wikipedia contributors. (2025, May 11). Binary search. In Wikipedia, The Free Encyclopedia. Retrieved 08:38, May 17, 2025, from https://en.wikipedia.org/w/index.php?title=Binary_search&oldid=1289880683],
)[
  In computer science, binary search, also known as half-interval search,
  logarithmic search, or binary chop, is a search algorithm that finds the
  position of a target value within a sorted array. Binary search compares the
  target value to the middle element of the array. If they are not equal, the
  half in which the target cannot lie is eliminated and the search continues on
  the remaining half, again taking the middle element to compare to the target
  value, and repeating this until the target value is found. If the search ends
  with the remaining half being empty, the target is not in the array.
]
