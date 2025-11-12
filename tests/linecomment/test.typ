#import "../../algorithmic.typ"
#import algorithmic: algorithm
#set page(margin: (left: .1cm, top: .1cm, bottom: .1cm), width: 8cm, height: auto)
#algorithm({
  import algorithmic: *
  LineComment(Assign[a][1], [Initialize $a$ to 1])
  LineComment([Initialize hashmap], [Count instances])
  LineComment(Break, [Early exit])
  LineComment([$c += a-b$], [Sum of differences])
  LineComment(IfElseChain([condition], {Line[Test]}), [It's just amazing])
  LineComment([], [blank])
  LineComment(While([stuff], {Line[Another test]}), [foo])
  LineComment(Function("add", ($a$, $b$), {Assign[c][$a+b$]}), [bar])
  LineComment(LineComment([nested], [inner]), [outer])
})
