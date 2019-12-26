# "123456789012" |
rtrimstr("\n") | split("") | map(tonumber) |

def log(s): . as $_ | [s] | debug | $_;

def pixels($w; $h):
  . as $_ |
  ($h * $w) as $n |
  reduce range(0; . | length; $n) as $i (
    [];
    . + [ $_[ $i : $i+$n ] ]
  )
;

def count($layer; $n): [$layer[] | select(. == $n)] | length;

pixels(25; 6) as $layers |

reduce $layers[] as $layer (
  { layer: $layers[0], length: count($layers[0]; 0) };
  count($layer; 0) as $length |
  if .length > $length then
    { layer: $layer, length: $length }
  else
    .
  end
) | .layer | count(.; 1) * count(.; 2)
