def decode:
	reduce split("")[] as $c (
    	{ code: split(""), i: 0, row: 0, col: 0, seat: 0 }; # initial state
      	.i = .i + 1 |
      	if .i < 8 then # rows
      		if $c == "B" then
      			.row = .row + 1 + (127 / pow(2; .i) | trunc)
      		else
      			.
      		end
      	else # cols
      		if $c == "R" then
      			.col = .col + 1 + (7 / pow(2; .i - 7) | trunc)
      		else
      			.
      		end
      	end
	) |
	.seat = .row * 8 + .col
;

rtrimstr("\n") | split("\n") | map(decode.seat) | max
