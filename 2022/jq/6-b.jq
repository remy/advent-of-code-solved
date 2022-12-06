14 as $n |
. as $input |
0 | until(
  ($input[.:.+$n] | explode | unique | length) == $n;
  . + 1
) |
. + $n
