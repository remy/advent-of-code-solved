reduce (rtrimstr("\n") | split("\n") | map(split(" ") | { dir: .[0], value: .[1] | tonumber }))[] as $move (
	{ depth: 0, hpos: 0, aim: 0 };
  	if $move.dir == "forward" then
  		.hpos += $move.value |
        .depth += (.aim * $move.value)
  	elif $move.dir == "down" then
  		.aim += $move.value
  	else
		.aim -= $move.value
  	end
) | .depth * .hpos
