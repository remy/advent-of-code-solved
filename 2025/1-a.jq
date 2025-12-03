{ L: -1, R: 1 } as $m |

[foreach inputs as $_ (
  50;
  (. + (
    100 +
    ($m[$_[:1]] * ($_[1:] | tonumber))
  )) % 100;
  if . == 0 then 1 else 0 end)] | add