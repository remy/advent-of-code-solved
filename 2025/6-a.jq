def mul: reduce .[] as $_ (1; . * $_);

# parse
[inputs | trim | split("\\s+"; null)] |

last as $ops |
.[0:-1] | map(map(tonumber)) |
. as $input |

reduce range(first | length) as $i (
  0;
  . + ($input | map(.[$i]) |
  if $ops[$i] == "+" then add else mul end)
)

