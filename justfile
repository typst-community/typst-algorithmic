version := "1.0.7"
typst := "typst"

docs:
    find docs -name '*.typ' -type f | xargs -I {} bash -c 'echo ------ Compiling "$1" && time typst compile --root . "$1" docs/assets/$(basename "$1" .typ).png' -- {}

version:
    {{typst}} --version

test:
    tt run # https://github.com/tingerrr/tytanic

test-update:
    tt update