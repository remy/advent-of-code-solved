def log(arg): . as $_ | [arg] | debug | $_;
def log: debug;

split(",") | map(tonumber) |

80 as $n |

# ($n / 7 | floor) as $q | log($q) |

# reduce range($q) as $i (
#   length;
#   length * 2
# ) | log

# map((. + 8) % 8)

max as $max | log($max) |

foreach range($max+1) as $i (
  .;
  reduce .[] as $e (
    [];
    if ($e-1) == -1 then
      . + [6, 8]
    else
      . + [$e - 1]
    end
  );
  if $i == ($max) then . else empty end
) | map(8 - .) | length as $a | ($n - ($max+1)) as $b | map((. + $b * 8) / $b | ceil)
