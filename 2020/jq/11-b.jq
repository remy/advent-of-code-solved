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

def lookup($c; $y; $x):
  # log($c, $x, $y) |
  ($c.x + $x) as $x1 |
  ($c.y + $y) as $y1 |
  if $x1 < 0 then empty
  elif $y1 < 0 then empty
  elif .grid[$y1][$x1] == floorSeat then lookup({ x: $x1, y: $y1 }; $y; $x)
  else .grid[$y1][$x1]
  end
;

def surrounding($c):
  [
    lookup($c; -1; -1),
    lookup($c; -1; 0),
    lookup($c; -1; 1),
    lookup($c; 0;  -1),
    lookup($c; 0;  1),
    lookup($c; 1; -1),
    lookup($c; 1; 0),
    lookup($c; 1; 1)
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
    if length >= 5 then emptySeat else $seat end
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
