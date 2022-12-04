def parse: split("\n") | map(select(. != "") | split(",") | map(split("-") | map(tonumber)));
def asRange:
	(flatten | { min: min, max: max }) as $range |
  map(
    (.[0] > $range.min) or (.[1] < $range.max)
  ) | select((.[0] and .[1]) | not)
;
parse | map(asRange) | length
