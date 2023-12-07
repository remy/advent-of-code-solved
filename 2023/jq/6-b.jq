def product: reduce .[] as $_ (1; . * $_);

[inputs] | map([match("(\\d+)"; "g")] | map(.captures[0].string) | join("") | tonumber) as [$t, $d] |

reduce range(1; $t) as $i (
  0;
  if ($i * ($t - $i)) > $d then
    . + 1
  end
)
