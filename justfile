version := "0.1.0"
typst := "typst"

docs:
    {{typst}} compile docs/algorithmic-demo.typ --root .

version:
    {{typst}} --version

test:
    tt run # https://github.com/tingerrr/tytanic
