include "./modules/log";

# "
# <x=-8, y=-10, z=0>
# <x=5, y=5, z=10>
# <x=2, y=-7, z=3>
# <x=9, y=-8, z=-3>
# " |

100 as $steps |

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

def velocity($key):
  . as $moons |
  map(
    . as $moon |
    .velocity = ($moons | reduce map(select(. != $moon))[] as $target (
      $moon.velocity;
      calcVelocityFor($key; $moon; $target)
    ))
  )
;

def gravity($key):
  map( . + {
    ($key): (.[$key] + .velocity[$key])
  })
;

def string:
  def v(key): .[key] | tostring | padLeft(2);
  "pos=<x=\(v("x")), y=\(v("y")), z=\(v("z"))>, vel=<x=\(.velocity | v("x")), y=\(.velocity | v("y")), z=\(.velocity | v("z"))>"
;

# https://rosettacode.org/wiki/Greatest_common_divisor#jq (sort of…)
def gcd(a; b):
  if b == 0 then
    0
  else
    def rgcd:
      if .[1] == 0 then
        .[0]
      else
        [.[1], .[0] % .[1]] | rgcd
      end;

    (a * b) / ([a,b] | rgcd)
  end
;

def gcd: reduce .[] as $value (.[0]; gcd(.; $value));

split("\n") |
map(select(. != "") | parse) |

map(.velocity = { x: 0, y: 0, z: 0 }) |

. as $initialState |

["x", "y", "z"] | map(

  { state: $initialState, steps: 0, dim: . } |

  until(
    .steps > 0 and (.state == $initialState);
    .dim as $key |
    .state = (.state | velocity($key) | gravity($key)) |
    .steps += 1
  ).steps
) | gcd
