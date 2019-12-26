# "0222112222120000" |
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

pixels(25; 6) | . as $layers | reduce range(0; 25 * 6) as $i ([];
  . + [[$layers | map(.[$i])[] | select(. != 2)][0]]
) | map(if . == 1 then "█" else "░" end) | . as $res | reduce range(0; 25) as $i (
  "";
  . + ($res[$i * 25: ($i * 25) + 25] | join("") + "\n")
)
