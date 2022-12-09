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

def find:
  map( # each row
    . as $input |
    [foreach range(0; length) as $i (
      $input[0];
      $input[$i] as $current |
      $input[$i+1:] |
      length as $n |
      if $n == 0 then
        0
      else
        until(
          (length == 0) or (first.value >= $current.value);
          .[1:]
        ) |

        if length == 0 then
          0
        else
          length - 1
        end |

        ($n - length)
      end |
      . as $score |

      $input[$i] + { score: ($score * ($input[$i].score // 1)) }
      ;

      . # emit
    )]
  )
;

parse |
find |
map(reverse) |
find |
transpose |
find |
map(reverse) |
find |
flatten |
max_by(.score) |
.score
