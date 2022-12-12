def log(s): . as $_ | if [s] | length > 0 then [s] | debug else empty end | $_;
def log(s): .; # this let's me turn logging on and off easily

def A: "a" | explode[0];
def START: "`" | explode[0]; # 83 = S
def END: "{" | explode[0]; # 69; # E
def parse: gsub("E"; "{") | gsub("a"; "S") | gsub("S"; "`") | split("\n") | map(select(. != "") | explode);
def toGrid:
  . as $input |
  reduce range (0; length) as $y (
    [];
    . + [reduce range(0; $input[$y] | length) as $x (
      [];
      . + [{
        value: $input[$y][$x],
        visited: false,
        x: $x,
        y: $y
      }]
    )]
  )
;

def getByValue($v): flatten | map(select(.value == $v) | del(.visited));

def initState:
  (getByValue(START) | map(. + { steps: 0, value: A })) as $pos |
  {
    grid: .,
    xMax: first | last | .x,
    yMax: last | first | .y,
    pos: $pos,
    all: [],
    found: [],
  };

def returnMoved($pos):
  if .visited == true then
    empty
  elif .value == ($pos.value + 1) or .value <= $pos.value then
    . + { steps: ($pos.steps + 1) } | del(.visited)
  else
    empty
  end
;

def moveV($pos; $i):
  if $pos.y == $i then
    empty
  else
    .grid[$pos.y - (if $i == 0 then 1 else -1 end)][$pos.x] | returnMoved($pos)
  end
;
def moveH($pos; $i):
  if $pos.x == $i then
    empty
  else
    .grid[$pos.y][$pos.x - (if $i == 0 then 1 else -1 end)] | returnMoved($pos)
  end
;
def moveUp($pos): moveV($pos; 0);
def moveDown($pos): moveV($pos; .yMax);
def moveLeft($pos): moveH($pos; 0);
def moveRight($pos): moveH($pos; .xMax);

def findNextMove:
  .pos as $pos |
  .pos = [] |
  reduce $pos[] as $pos (
    .;
    .pos += [
      moveUp($pos),
      moveDown($pos),
      moveLeft($pos),
      moveRight($pos)
    ] |

    .grid = reduce .pos[] as $pos (
      .grid;
      setpath([$pos.y, $pos.x]; .[$pos.y][$pos.x] + { visited: true })
    ) |

    if $pos.value == END then
      .found = $pos
    else . end
  )
;

parse |
toGrid |
initState |
until(.pos | length == 0; findNextMove).found.steps
