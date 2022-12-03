def mapToNumbers: explode | map(. - 96) | map(if . < 0 then . + 58 else . end);

def findRepeating:
  length as $l | split("") |
  (reduce .[0:$l/2][] as $_ ({}; . + { "\($_)": 1 } )) as $start |
  reduce .[$l/2:][] as $_ ($start; if .[$_] == 1 then .[$_] += 1 else . end) |
  to_entries | map(select(.value > 1)) | first.key
;

def parse: split("\n") | map(select(. != ""));

parse | map(findRepeating) | join("") | mapToNumbers | add
