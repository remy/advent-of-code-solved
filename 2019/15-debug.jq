include "./modules/log";
import "./modules/paint" as PIXELS;
import "./modules/intcode" as INTCODE;

def coords(c): c | join(",");

0 as $WALL |
1 as $FREE |
2 as $OXYGEN |
3 as $UNKNOWN |
4 as $BLOCKED |
5 as $ROBOT |
6 as $START |
7 as $RETRACE |
8 as $OXYGEN_MARKER |
[1,2,3,4] as [$N, $S, $W, $E] |


def move(dir):
  if dir == $N then
    .[1] -= 1
  elif dir == $S then
    .[1] += 1
  elif dir == $W then
    .[0] -= 1
  elif dir == $E then
    .[0] += 1
  else
    "bad direction: \(.), dir: \(dir)" | halt_error
  end
;

def rotate(dir):
  if dir == $N then
    $E
  elif dir == $E then
    $S
  elif dir == $S then
    $W
  elif dir == $W then
    $N
  else
    "bad rotation: \(dir)" | halt_error
  end
;

def rotate:
  .direction = rotate(.direction) |
  INTCODE::readIn(.direction)
;

def rotate180:
  rotate | rotate
;


def expand:
  . as $res |
  .grid | map_values(select(. == $OXYGEN_MARKER)) |
  reduce to_entries[] as $coords (
    $res;
    . as $res |
    reduce [1,2,3,4][] as $dir (
      [];
      coords($coords.key | split(",") | map(tonumber) | move($dir)) as $coord |
      $res.grid[$coord] as $point |
      if $point != $WALL and $point != $OXYGEN then
        . + [$coord]
      else
        .
      end
    ) |
    . as $options |

    if length == 0 then
      $res
    else
      reduce .[] as $point (
        $res;
        .grid[$point] = $OXYGEN_MARKER
      )
    end

    | .grid[$coords.key] = $OXYGEN

  )
;

.i = 0 |
.grid[coords(.oxygen)] = $OXYGEN_MARKER |
while(
  .grid | map_values(select(. != $OXYGEN and . != $OXYGEN_MARKER and . != $WALL)) | length != 0;
  .i += 1 |
  expand
) |
[.i + 1, (.grid |PIXELS::paint(["█"," ","O","▒", "░", "o", "S", "⸬", "0", "█"]; 9))][]
