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
map(
  pow(2; . - 1) |
  floor
) |
add
