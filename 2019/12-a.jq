include "./modules/log";

# "<x=-8, y=-10, z=0>
# <x=5, y=5, z=10>
# <x=2, y=-7, z=3>
# <x=9, y=-8, z=-3>
# " |

1000 as $steps |

def parse:
  sub("[<>]"; ""; "g") | # strip wrapping <…>
  split(",\\s+"; "g") | # split x, y, z
  map({ (split("=")[0]): split("=")[1] | tonumber }) | # convert to object
  add
;

def padLeft(n; value): . as $_ | [range(0; n - length)] | reduce .[] as $i ($_; value + .);
def padLeft(n): padLeft(n; " ");

def calcVelocityFor($key; $moon; $target):
  if $moon[$key] < $target[$key] then
    .[$key] += 1
  elif $moon[$key] > $target[$key] then
    .[$key] -= 1
  else
    .
  end
;

def velocity:
  . as $moons |
  map(
    . as $moon |
    .velocity = ($moons | reduce map(select(. != $moon))[] as $target (
      $moon.velocity;
      calcVelocityFor("x"; $moon; $target) |
      calcVelocityFor("y"; $moon; $target) |
      calcVelocityFor("z"; $moon; $target)
    ))
  )
;

def gravity:
  map( . + {
    x: (.x + .velocity.x),
    y: (.y + .velocity.y),
    z: (.z + .velocity.z),
  })
;

def string:
  def v(key): .[key] | tostring | padLeft(2);
  "pos=<x=\(v("x")), y=\(v("y")), z=\(v("z"))>, vel=<x=\(.velocity | v("x")), y=\(.velocity | v("y")), z=\(.velocity | v("z"))>"
;

def energy:
  ([del(.velocity) | to_entries[].value | fabs] | add) *
  ([.velocity | to_entries[].value | fabs] | add)
;

split("\n") |
map(select(. != "") | parse) |

map(.velocity = { x: 0, y: 0, z: 0 }) |

foreach range(0; $steps) as $i (
  .;
  # update
  velocity | gravity;
  if $i == ($steps - 1) then . else empty end
) | map(energy) | add

# | map(string) | join("\n")
