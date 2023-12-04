[inputs] |
map(
  split(":") | last
) |
map(
  # originally done with a regexp, but it was bad!
  split("|") |
  map(
    split(" ") |
    map(
      select(. != "") |
      tonumber
    ) |
    sort
  ) as [$a, $b] |
  $b | unique |
  [indices($a | unique[])] |
  flatten |
  length
) |
[
  with_entries(.key |= tostring | .value += 1),
  ([range(length)] | map(1) | with_entries(.key |= tostring))
] as [$wins, $results] |

reduce range(length) as $i (
  $results;
  . as $input |
  reduce (range($i + 1; $i + $wins["\($i)"])) as $j (
    $input;
    . + { "\($j)": (.["\($j)"] + .["\($i)"] )}
  )
) | to_entries | map(.value) | add
