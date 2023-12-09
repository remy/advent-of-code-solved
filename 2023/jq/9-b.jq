[inputs | split(" ") | map(tonumber) |

[while(
  all(. == 0) | not;
  . as $input |
  reduce range(0; length - 1) as $_ (
    [];
    . + [ $input[$_ + 1] - $input[$_] ]
  )
) | first] | reverse | reduce .[] as $_ (0; $_ - .)] | add
