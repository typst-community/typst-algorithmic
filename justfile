version := "1.0.2"
typst := "typst"

docs:
    find docs/*.typ -type f | xargs -I {} fish -c 'echo ------ Compiling $argv[1] && time {{typst}} compile --root . $argv[1] docs/assets/$(basename $argv[1] .typ).png' {}

version:
    {{typst}} --version

test:
    tt run # https://github.com/tingerrr/tytanic

test-update:
    tt update