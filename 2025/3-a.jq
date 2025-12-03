def findLargest:
  . as $_ |
  # note, we can't use the last number
  .[0:-1] | max as $max |
  $_ | index($max) as $index |
  $_[0:$index] + $_[$index+1:] | max as $next |
  [$max, $next] | join("") | tonumber
;

[inputs | split("") | map(tonumber) | findLargest]