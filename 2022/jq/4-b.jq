def parse: split("\n") | map(select(. != "") | split(",") | map(split("-") | map(tonumber)));

parse | map(
	(flatten | max - min) as $range |
	map(max - min) | add | ($range - .)
) | map(select(. > 0 | not)) | length
