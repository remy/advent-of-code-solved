def debug(n): . as $_ | n | debug | $_;

def print:
  . as $state |
  foreach $state.grid[] as $line (
    -1;
    . += 1;
    . as $y |
    [range(0; $state.w)] | map(
      . as $x |
      if ($state.track | index("\($x),\($y)")) then
        "X"
      else
        $line[$x]
      end
    ) | join("")
  )
;

def track: ["\(.ptr.x),\(.ptr.y)"];

def move($dx; $dy):
  . as $state |
  (.ptr.x + $dx) as $x |
  (.ptr.y + $dy) as $y |
  # check bounds
  if $x < 0 or $x > .w or $y < 0 or $y > .h then
    .
  elif .grid[$y][$x] == "#" then
    move($dy * -1; $dx)
  else
    .ptr.x = $x |
    .ptr.y = $y |
    track as $track |
    if (.track | index($track)) == null then
      .track += track |
      .visited += 1
    end |
    move($dx; $dy)
  end
;

def find($chr):
	. as $_ |
	{ x: null, y: 0 } |
	until (
		.x != null;
    .y += 1 |
    .x = ($_[.y] | index($chr))
	)
;

def initGrid:
	{
		w: .[0] | length,
		h: length,
    ptr: find("^"),
    track: [],
    visited: 0,
		grid: .,
	}
;

[inputs/""] | initGrid | move(0;-1) | .visited