def parse:
	split("\n") |
	map(select(. != "") |
	    split("") |
		map(tonumber)
	) |
	to_entries |
	map(
		.key as $y |
      	.value |
      	to_entries |
      	map(
			. + { x: .key, y: $y } |
          	del(.key)
		)
	)
;

def find($trees):
  $trees |
	.[1:-1] |
  map(
    first as $first |
    .[1:-1] |
      # log($first,.)|
    reduce .[] as $_ (
      [$first];
      if $_.value > last.value then
        . + [$_]
      else
        .
      end
    ) | .[1:]
  )
;

parse |
. as $input |
[
  find(.),
  find(map(reverse)),
  find(transpose),
  find(transpose | map(reverse))
] |
flatten |
map(select(. != null)) |
unique |
length as $inner |
$input |
first |
length * 2 + ($input | transpose | first | (length - 2) * 2) + $inner
