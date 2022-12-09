def log(s): . as $_ | if [s] | length > 0 then [s] | debug else empty end | $_;
def log(s): .; # this let's me turn logging on and off easily

def parse: split("\n") | map(select(. != "") | split(" ") | { dir: .[0], n: .[1] | tonumber }) ;

def calcGrid:
  [{  x: 0, y: 0 }] as $grid |
  . as $steps |
  reduce range(0; length) as $i (
    $grid;
    if $steps[$i].dir == "R" then
      . + [{ x: (last.x + $steps[$i].n), y: last.y }]
    elif $steps[$i].dir == "L" then
      . + [{ x: (last.x - $steps[$i].n), y: last.y }]
    elif $steps[$i].dir == "U" then
      . + [{ x: last.x, y: (last.y + $steps[$i].n) }]
    else
      . + [{ x: last.x, y: (last.y - $steps[$i].n) }]
    end
  ) | {
    width: ((max_by(.x).x - min_by(.x).x) + 1),
    height: ((max_by(.y).y - min_by(.y).y) + 1),
    extra: [(min_by(.x).x | fabs), (min_by(.y).y | fabs)]
  }
;

def repeatN($n): . as $_ | [range(0; $n)] | map($_) | join("");
def stepValue($tail; $x; $y):
    ($tail | index({ x: $x, y: $y })) as $index |
    if .s then
      "s"
    elif .h then
      "H"
    elif .t then
      "T"
    elif .visited then
      "#"
    elif $index != null then
      ($index + 1) | tostring
    else
      "."
    end
;
def renderState($grid):
  .snake as $tail |
  .grid as $movement |
  reduce range(0; $grid.height) as $y (
    [];
    . + [reduce range(0; $grid.width) as $x (
      [];
      . + [($movement[$y][$x] | stepValue($tail; $x; $y)) // "."]
    ) | join("")]
  ) | reverse | join("\n");

def splitter($n): "~" | repeatN($n);
def clear: "\n" | repeatN(38);
def count: flatten | map(select(.visited)) | length;
def render($grid): "\(clear)\(splitter($grid.width))\n\(renderState($grid))\n\(splitter($grid.width))\n\(count)";
# def render($grid): count;

def setInitialPoint($grid):
  { x: $grid.extra[0], y: $grid.extra[1] } as $init |
  log("init", $init) |
  .grid[$init.y][$init.x] = { visited: true, h: true, s: true } + $init |
  .snake = ([range(0;9)] | map($init)) |
  .tail = $init |
  .head = $init |
  .
;

def init($grid):
  reduce range(0; $grid.height) as $y (
    [];
    . + [reduce range(0; $grid.width) as $x (
      [];
      . + [{ x: $x, y: $y, visited: false }]
    )]
  ) |
  { grid: . } |
  setInitialPoint($grid)
;


def remove($point): .grid[.[$point].y][.[$point].x][$point[0:1]] = false | .;
def add($point): .grid[.[$point].y][.[$point].x][$point[0:1]] = true | .;

def visit: .grid[.tail.y][.tail.x].visited = true | . ;

def moveSingleAxis($x; $y):
  if $x > 1 then
    .tail.x += ($x-1)
  elif $x < -1 then
    .tail.x -= 1
  else
    .
  end |

  if $y > 1 then
    .tail.y += ($y-1)
  elif $y < -1 then
    .tail.y -= 1
  else
    .
  end
;

def moveT($head):
  ($head.x - .tail.x) as $x |
  ($head.y - .tail.y) as $y |

  if $y == 0 or $x == 0 then # single axis movement
    moveSingleAxis($x; $y)
  else # diagonal
    if ($y | fabs == 2) and ($x | fabs == 2) then
      moveSingleAxis(0; $y) |
      moveSingleAxis($x; 0)
    elif $y | fabs == 2 then
      .tail.x = $head.x |
      moveSingleAxis(0; $y)
    elif $x | fabs == 2 then
      .tail.y = $head.y |
      moveSingleAxis($x; 0)
    else
      .
    end
  end
;

def moveTails:
  reduce range(0; .snake | length) as $i (
    .;
    .tail = .snake[$i] |
    moveT(if $i == 0 then .head else .snake[$i - 1] end) |
    .snake[$i] = .tail
  ) |
  visit # only apply to the _end_ of the tail
;

def moveH($axis; $direction):
  remove("head") |
  .head[$axis] = (.head[$axis] + $direction) |
  add("head") |
  moveTails
;
def moveH($axis): moveH($axis; 1);


def walkSteps($state; $grid):
  . as $steps |
  foreach range(0; length) as $i (
    $state;
    # update
    $steps[$i] as $dir |

    if $dir == "R" then
      log("R") |
      moveH("x")
    elif $dir == "L" then
      log("L") |
      moveH("x"; -1)
    elif $dir == "D" then
      log("D") |
      moveH("y"; -1)
    else
      log("U") |
      moveH("y")
    end;
    render($grid)
  )
;

def explodeSteps:
  reduce .[] as $step (
    [];
    . + ([range(0; $step.n)] | map($step.dir))
  )
;

parse |
calcGrid as $grid |
explodeSteps |
walkSteps(init($grid); $grid)
