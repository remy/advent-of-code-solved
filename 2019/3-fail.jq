# parse

def parse:
 split(",")
 | map({ dir: .[:1], n: .[1:] | tonumber })
;

def slurp:
  [split("\n")[] | select(. != "")]
;

def dimToMatrix:
  debug |
   . as $dims | [range(0; $dims.w)] | map([range(0; $dims.h) | 0])
;

def buildMatrix:
  reduce .[] as $path (
    { w: 0, h: 0, x: 1, y: 1 };
    if $path.dir == "R" then
      { w: (.x + $path.n + .w), h, x: (.x + $path.n), y }
    elif $path.dir == "U" then
      { w, h: (.y + $path.n + .h), x, y: (.y + $path.n) }
    elif $path.dir == "L" then
      { w: (.w + ([.x - $path.n, 0] | min * -1)), h, x: ([.w - .x, 0] | max), y }
    elif $path.dir == "D" then
      { w, h: (.h + ([.y - $path.n, 0] | min * -1)), x, y: ([.h - .y, 0] | max) }
    else
      .
    end
  )
;

[slurp | map(parse)[]] as $paths |
[$paths[] | buildMatrix] | reduce .[] as $_ ({ w: 0, h: 0 }; {
  w: [.w, $_.w] | max, # work out which is the largest matrix
  h: [.h, $_.h] | max,
}) | dimToMatrix as $matrix

| reduce $paths[] as $path (
  $matrix;
  reduce $path[] as $p (
    $matrix;
    . as $_ | debug | $_
    # map(
    #   reduce .[] as $n (
    #     .;
    #     . + [range(0; $p.n) | 1]
    #   )
    # )
  )
)

# # project
# reduce .[] as $path (
#   [[-1]];
#   . as $root |
#   length as $x |
#   .[0] | length as $y |
#   $root |
#   if $path.dir == "R" then
#     map(
#       reduce $path.n as $n (
#         .;
#         . + [range(0; $n) | 1]
#       )
#     )
#   elif $path.dir == "U" then
#     map(
#       reduce $path.n as $n (
#         .;
#         . + [range(0; $n) | 2]
#       )
#     )
#   else
#     "Unknown direction \($path)" | halt_error
#   end
# )
# calculate

# ..|
# o-+

# [[-1]] - init

# [[-1,1,1,1]] - R3

# [[0,0,0,1],[-1,1,1,1]] - U1

# [
#   [0,0,0,1],
#   [-1,1,1,1]
# ]


# R3,U5,L2,D3
#  +-+
#  |.|
#  |.|
#  |.|
#  ..|
#  --+
#
#

