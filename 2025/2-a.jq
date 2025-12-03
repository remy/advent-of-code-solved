[inputs | split(",")] | flatten | map(select(. != "")) | # format

def repeatstr($offset; $n):
  .[0:$offset] as $val |
  [range($n) | $val] | join("")
;


map(
  split("-") |
  map(tonumber) |
  range(.[0]; .[1]+1) |
  tostring |
  select(
    length % 2 == 0 and
    . == repeatstr(length/2; 2)
  ) |
  tonumber
) |

add