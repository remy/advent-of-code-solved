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
[1,2,3,4] as [$N, $S, $W, $E] |

split(",") | map(tonumber) as $memory |

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
    "bad direction: \(.)" | halt_error
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

def get($dir; $_):
  $_ | (.grid[coords(.position | move($dir))] // $UNKNOWN)
;

def tryTurning:
  . as $res |
  .direction as $dir |
  if .steps == 0 and get($dir; .) == $UNKNOWN then
    .
  else
    [1,2,3,4] |
    map([., get(.; $res)]) |
    sort_by(.[1]) |
    reverse |
    map(select(
      if $res.steps > 0 then
        .[1] == $FREE
      else
        (.[1] != $WALL) and (.[1] != $BLOCKED) and (.[1] != $OXYGEN)
      end
    )) |
    . as $options |

    if length == 1 then
      $res | .direction = $options[0][0] |
      if .steps > 0 then
      .grid[coords(.position)] = $RETRACE
      else
        .grid[coords(.position)] = $BLOCKED
      end
    elif ($res.steps > 0) and ($options[0] == null) then
      $res
    else
      $res | .direction = $options[0][0] // $dir
    end
  end
;

def run:
  . as $memory |
  INTCODE::init |

  .grid = {} | #([[range(0; 50)] | combinations(2)] | map({ (coords(.)): $UNKNOWN }) | add ) |
  .start = [0,0] |
  .steps = 0 |
  .position = .start |
  .oxygen = null |
  .direction = $N |
  .i = 0 |

  INTCODE::readIn(.direction) |

  until(
    .halted;
    INTCODE::step |
    .draw = false |

    # if .i == 200 then .halted = true else . end |
    if .oxygen and .position == .start then
      .halted = true
    elif .output then
      .i += 1 |
      if .i % 5 == 0 then .draw = true else . end |
      if .grid[coords(.position)] != $BLOCKED then
        .grid[coords(.position)] = $FREE
      else
        .
      end |
      .direction as $dir |
      if .output == $WALL then
        .grid[coords(.position)] = $ROBOT |
        .grid[coords(.position | move($dir))] = $WALL |
        tryTurning | INTCODE::readIn(.direction)
      else
        .direction as $dir |
        .position = (.position | move($dir)) | # update the current position of where the robot is

        if .output == $OXYGEN then
          .oxygen = .position
        else
          .
        end |

        .grid[coords(.position)] = $ROBOT |
        tryTurning |
        INTCODE::readIn(.direction)
      end
    else
      .
    end
  )
;

def expand:
  . as $res |
  .grid | map_values(select(. == $OXYGEN)) |
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
        .grid[$point] = $OXYGEN
      )
    end
  )
;

# set to true to watch robot moving around
$memory | run | .grid[coords(.oxygen)] = $OXYGEN | .i = 0 |
while(
  .grid | map_values(select(. != $OXYGEN and . != $WALL)) | length != 0;
  .i += 1 | # count the seconds
  expand # keep expanding the gas
) |
# display
[.i + 1, (.grid |PIXELS::paint(["█"," ","O","▒", "░", "o", "S", "⸬", "█"]; 8))][]

