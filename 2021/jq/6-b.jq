split(",") | map(tonumber) |

256 as $n |

foreach range($n) as $i (
  .;
  reduce .[] as $e (
    [];
    if ($e-1) == -1 then
      . + [6, 8]
    else
      . + [$e - 1]
    end
  );
  if $i == ($n-1) then . else empty end
) | length
