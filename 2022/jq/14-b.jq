def log(s): . as $_ | if [s] | length > 0 then [s] | debug else empty end | $_;
def log(s): .; # this let's me turn logging on and off easily

def parse:
	split("\n") |
	map(select(. != "") |
    split(" -> ") |
    map(
      split(",") as [$x, $y] |
      { x: $x | tonumber, y: $y | tonumber }
	)
);

def findMinMax($axis): flatten | [min_by(.[$axis]), max_by(.[$axis])] | map(.[$axis]);

def generateRocks($axis; $a; $b):
  ([$b[$axis], $a[$axis]] | sort) as [$min, $max] |
  reduce range($max; $min - 1; -1) as $i (
    .;
    if $axis == "x" then
      .[$a.y] += [$i]
    else
      .[$i] += [$a.x]
    end
  )
;

def generateGrid:
  . as $input |
  reduce range(length) as $i (
    [];
    $input[$i] as [$a, $b] |
    if $b != null then
      generateRocks(if $a.y != $b.y then "y" else "x" end; $a; $b)
    else
      .
    end
  )
;

def vectorise:
  . as $input |
  reduce range(length) as $i (
    [];
    $input[$i:$i+2] as [$a, $b] |
    if $b != null then
      . + [[$a, $b]]
    else . end
  )
;

def getNextSpots:
  .sand as { $x, $y } |
  (.grid[$y + 1] // []) | [
    contains([$x - 1]),
    contains([$x]),
    contains([$x + 1])
  ] | map(not)
;

def dropSand:
  .sand.lastY = .sand.y |
  getNextSpots as $moves |
  log("fall", .sand, .grains, $moves) |
  if .sand.y == .floor then
    .grid[.sand.y] += [.sand.x]
  elif $moves[1] then
    .sand.y += 1
  elif $moves[0] then
    .sand.y += 1 |
    .sand.x -= 1
  elif $moves[2] then
    .sand.y += 1 |
    .sand.x += 1
  else
    # at rest
    .grid[.sand.y] += [.sand.x] |
    log("at rest", .sand, .grid[.sand.y])
  end
;

def tick:
  .grains += 1 |
  [recurse(
    dropSand
  ; (.sand.lastY == .sand.y) | not)] | last | dropSand
;

def repeatN($n): . as $_ | [range(0; $n)] | map($_) | join("");
def clear: "\n" | repeatN(38);

def render:
  . as $input |
  (.grid | map(select(length > 0) | [min, max]) | flatten | [min, max]) as [$min, $max] |
  reduce range(.grid | length) as $y (
    [];
    $input.grid[$y] as $row |
    . + [reduce range($min; $max + 1) as $i (
      "";
      if $input.sands | index({ x: $i, $y }) then
        . + "o"
      else
        . + (if $row | contains([$i]) then "#" else "." end)
      end
    )]
  ) | join("\n") | "\(.)\nGrains: \($input.grains + 1)"
;

log("===================") |

parse | map(vectorise) | flatten(1) | generateGrid | {
  grid: (map(if . == null then [] else unique end) + [[]]),
  floor: length,
  grains: 0,
  sands: [],
  halt: false,
} |
[recurse(
  .sand = { x: 500, y: 0, lastY: -1 } |
  tick |
  log(.sand) |
  .sands += [.sand | del(.lastY)];
  .sand.y != 0
)] | last | .grains + 1

