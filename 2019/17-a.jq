include "./modules/log";
import "./modules/intcode" as INTCODE;

def icons: [range(47)] | map(" ") | .[10]="\n" | .[35]="#" | .[46]=".";

def convertToMap:
  INTCODE::init |
  [while(
    .halted | not;
    INTCODE::step
  )] |
  map(
    select(.output) |
    icons[.output]
  );

def toCoord(w; i): { x: (i % w), y: ((i / w) | floor) };

def convertToGrid:
  map(select(. != "\n")) as $_ |
  index("\n") as $width |
  $_ | to_entries | map(
    toCoord($width; .key) as { $x, $y } |
    { value, x: $x, y: $y } |
    select(.value == "#")
  )
;

def getPoint($grid; $x; $y):
  $grid |
  map(
    select(.x == $x and .y == $y)
  ) |
  if length > 0 then last else empty end
;

def getPoint(x; y): getPoint(.; x; y);

def findIntersection(point; grid):
  if point.y != 0 and point.x != 0 then
    grid | [
      getPoint((point.x-1); point.y),
      getPoint((point.x+1); point.y),
      getPoint(point.x; (point.y-1)),
      getPoint(point.x; (point.y+1))
    ] | length == 4
  else
    false
  end
;

def countIntersections:
  . as $grid |
  (length-1) as $last |
  foreach range(length) as $i (
		.;
		.[$i].intersection = findIntersection(.[$i]; $grid);
		if $i == $last then . else empty end
	)
;

split(",") | map(tonumber) as $memory |
$memory |
convertToMap |
convertToGrid |
countIntersections |
map(select(.intersection) | .x * .y) | add


