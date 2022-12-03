def mapToNumbers: explode | map(. - 96) | map(if . < 0 then . + 58 else . end);

def findRepeating:
  . as $in |
  (reduce ($in[0] | split(""))[] as $_ ({}; . + { "\($_)": 1 } )) | . as $a |
  reduce ($in[1] | split(""))[] as $_ ($a; if .[$_] == 1 then .[$_] += 1 else . end) | . as $b |
  reduce ($in[2] | split(""))[] as $_ ($b; if .[$_] == 2 then .[$_] += 1 else . end) |
  to_entries | map(select(.value > 2)) | first.key
;

def parse: split("\n") | map(select(. != ""));

def group($n): . as $input | reduce range (0; length; $n) as $i ([]; . + [$input[$i:$i+$n]]);

#parse | map(findRepeating)
parse | group(3) | map(findRepeating) | join("") | mapToNumbers | add
