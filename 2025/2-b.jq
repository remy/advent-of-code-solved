[inputs | split(",")] | flatten | map(select(. != "")) | # format

def repeatstr($offset; $n):
  .[0:$offset] as $val |
  [range($n) | $val] | join("")
;

def invalid:
  . as $value |
  length as $length |

  # get the comparison ranges
  [
    range(2; length | ceil + 1) |
    ($length / .) |
    select(. == floor) |
    select(
      . as $i |
      $value | . == repeatstr($i; $length / $i)
    )
  ] | length > 0
;

map(
  split("-") |
  map(tonumber) |
  range(.[0]; .[1]+1) |
  tostring |
  select(invalid) |
  tonumber
)

| add