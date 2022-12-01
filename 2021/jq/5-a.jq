def log(arg): . as $_ | [arg] | debug | $_;
def log: debug;

def parse:
  rtrimstr("\n") |
  split("\n") |
  map(
    split(" -> ") |
    map(
      split(",") |
      { x: .[0] | tonumber, y: .[1] | tonumber }
    )
  )
;

def filterFlat:
  map(select(
    if .[0].x == .[1].x or .[0].y == .[1].y then true else false end
  ))
;

def findOverlap(dir):
  . as $_ |
  map(select(
    . as $__ |
    # for each individual - see if we can find another
    $_ | map(select(
      .[0][dir] == $__[0][dir]
    )) | length > 1
  ))
;

def render:
.
;

log(">>> start >>>") |

parse | filterFlat | [findOverlap("x")]
