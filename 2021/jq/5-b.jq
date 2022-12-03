def log(s): . as $_ | [s] | debug | $_;

def findMax($axis): map(map(.[$axis])) | flatten | max;
def generateGrid($width; $height): reduce range (0; (($width+1) * ($height+1))) as $i ([]; . + [0]) ;
def getIforXY($x; $y; $width): $width * $y + $x;
def dir($p1; $p2; $_): if $p1[$_] < $p2[$_] then 1 else -1 end;
def rangeFor($p1; $p2; $_): dir($p1; $p2; $_) as $dir | range($p1[$_]; $p2[$_] + $dir; $dir);
def interpolate($p1; $p2):
	if $p1.x == $p2.x then
		# horizontal
		reduce rangeFor($p1; $p2; "y") as $y ([]; . + [{ x: $p1.x, y: $y }])
	elif $p1.y == $p2.y then
		# vertical
		reduce rangeFor($p1; $p2; "x") as $x ([]; . + [{ x: $x, y: $p1.y }])
	else
		[[rangeFor($p1; $p2; "x")], [rangeFor($p1; $p2; "y")]] | transpose | map({ x: .[0], y: .[1]})
	end
;
def interpolate: interpolate(.[0]; .[1]);

split("\n") | map(split(" -> ") | map(split(",") | map(tonumber) | { x: .[0], y: .[1] })) |
. as $data |

# find min and max
findMax("x") as $width |

map(interpolate | map(getIforXY(.x; .y; $width))) |
flatten | sort | reduce .[] as $_ ({}; .["\($_)"] += 1) |
to_entries | map(select(.value > 1)) | length
