. as $source |

def slurp: [split("\n")[] | select(. != "")];

def load(key):
  . as $_ |
  reduce .[key?][] as $curr (
    if ["YOU","SAN"] | contains([key]) then { (key): true } else {} end;
    . + { ($curr): ($_ | load($curr)) }
  )
;

$source | slurp | map(split(")")) | reduce .[] as [$p, $o] (
  {};
  . + { ($p): (.[$p] + [$o]) }
) | load("COM") |
[paths(scalars) | .[:-2]] | # find YOU and SAN and remove the last two (bugs)
. as $res | map(length) | max | # find the longest path length
reduce range(0; .) as $i (
  0;
  if $res[0][$i] == $res[1][$i] then . + 1 else . end # count the overlap
) | $res[0][.:] + $res[1][.:] | length # add up the length - overlap

