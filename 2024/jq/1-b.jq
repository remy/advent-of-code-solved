[inputs] |
map(
  split("\\s+"; null) |
  map(tonumber)
) |
transpose |
map(sort) |
. as $_ |
reduce range(.[0] | length) as $i (
  0;
  . + ($_[0][$i] * ($_[1] | map(
    select(. == $_[0][$i])
  ) | length))
)