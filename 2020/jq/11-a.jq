def log(s): . as $_ | [s] | debug | $_;

def toCoords($i):
  { x: ($i % .w), y: (($i / .w) | floor) }
;

def parse:
  rtrimstr("\n") | split("\n") | map(split("")) |
  { grid: ., flat: flatten, w: .[0] | length, length: flatten | length }
;

def emptySeat: "L";
def floorSeat: ".";
def occupiedSeat: "#";

def lookup($y; $x):
  if $x < 0 then empty
  elif $y < 0 then empty
  else .grid[$y][$x]
  end
;

def surrounding($c):
  [
    lookup($c.y-1; $c.x-1),
    lookup($c.y-1; $c.x),
    lookup($c.y-1; $c.x+1),
    lookup($c.y; $c.x-1),
    lookup($c.y; $c.x+1),
    lookup($c.y+1; $c.x-1),
    lookup($c.y+1; $c.x),
    lookup($c.y+1; $c.x+1)
  ]
;

def adjacent($i):
  toCoords($i) as $c |
  .grid[$c.y][$c.x] as $seat |
  if $seat == floorSeat then
    $seat
  elif $seat == emptySeat then
    # check surrounding seats
    surrounding($c) | map(select(. == occupiedSeat)) |
    if length == 0 then occupiedSeat else $seat end
  elif $seat == occupiedSeat then
    surrounding($c) | map(select(. == occupiedSeat)) |
    if length >= 4 then emptySeat else $seat end
  else
    $seat
  end
;

def transform($w):
  . as $_ |
  reduce range(0; length) as $i (
    [];
    .[($i / $w) | floor][$i % $w] = $_[$i]
  )
;

def test:
  . as $_ |
  .flat as $before |
  . + { flat: [range(0; $_.length)] | map(
    . as $i |
    $_ | adjacent($i)
  ) } |
  .grid = (.flat | transform($_.w)) |
  if .flat != $before then
    test
  else
    .
  end
;

parse | test | .flat | map(select(. == "#")) | length
