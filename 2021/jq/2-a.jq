reduce (rtrimstr("\n") | split("\n") | map(split(" ") | { dir: .[0], value: .[1] | tonumber }))[] as $move (
	{ depth: 0, hpos: 0 };
  	if $move.dir == "forward" then
  		.hpos += $move.value
  	elif $move.dir == "down" then
  		.depth += $move.value
  	else
		.depth -= $move.value
  	end
) | .depth * .hpos
