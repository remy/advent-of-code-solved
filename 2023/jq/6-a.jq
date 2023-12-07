def product: reduce .[] as $_ (1; . * $_);

[inputs] | map([match("(\\d+)"; "g")] | map(.captures[0].string | tonumber)) as [$time, $distance] |

[range(0; $time | length)] | map(
  $time[.] as $t |
  $distance[.] as $d |

  reduce range(1; $t) as $i (
    0;
    if ($i * ($t - $i)) > $d then
      . + 1
    end
  )
) | product
