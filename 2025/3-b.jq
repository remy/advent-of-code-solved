def findLargest($n):
  . as $_ |

  .[0:(if $n == 1 then length else 1-$n end)] | max as $max |
  $_ | index($max) as $index |
  if ($n - 1) > 0 then
    [$max] + ($_[$index+1:] | findLargest($n-1))
  else
    [$max]
  end
;

[inputs | split("") | map(tonumber) | findLargest(12) | join("") | tonumber] | add
