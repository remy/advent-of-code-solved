def log(s): . as $_ | [s] | debug | $_;

def toCoords($i):
  { x: ($i % .w), y: (($i / .w) | floor) }
;

def ROLL: "@";
def LIFTED: "x";

def lookup($c; $y; $x):
  ($c.x + $x) as $x1 |
  ($c.y + $y) as $y1 |
  if $x1 < 0 then empty
  elif $y1 < 0 then empty
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

def parse:
  map(split("")) |
  { grid: ., flat: flatten, w: .[0] | length, length: flatten | length }
;

def process:
  . as $_ |
  [range(0; $_.length)] |
  map(
    . as $i |
    $_ |
    toCoords($i) as $c |
    .grid[$c.y][$c.x] as $place |
    if $place == ROLL then
      # check surrounding seats
      surrounding($c) |
      map(select(. == ROLL)) |
      if length < 4 then LIFTED else $place end
    else
      $place
    end
  )
;

[inputs] |
parse |
process |
map(select(. == LIFTED)) |
length
