include "./modules/log";
import "./modules/paint" as PIXELS;
import "./modules/intcode" as INTCODE;

def coords(c): c | join(",");

0 as $WALL |
1 as $FREE |
2 as $OXYGEN_TANK |
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
  $_ | (.grid[coords(.position | move($dir))] // 3)
;


def tryTurning($forced):
  . as $res |
  .direction as $dir |
  if .steps == 0 and get($dir; .) == $UNKNOWN then
    .
  else
    [1,2,3,4] | reverse |
    map([., get(.; $res)]) |
    sort_by(.[1]) |
    reverse |
    map(select(
      if $res.steps > 0 then
        .[1] == $FREE
      else
        (.[1] != $WALL) and (.[1] != $BLOCKED) and (.[1] != $OXYGEN_TANK)
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

def tryTurning: tryTurning(false);
def forceTurning: tryTurning(true);

def findPathBack:
  .steps = 1 |
  [while(
    .position != .start;
    .steps += 1 |
    tryTurning |
    .direction as $dir |
    .position = (.position | move($dir)) |
    .grid[coords(.position)] = $ROBOT
  )
  ] | last | .steps += 1 # account for the last step
;

def run:
  . as $memory |
  INTCODE::init |

  .grid = ([[range(0; 50)] | combinations(2)] | map({ (coords(.)): $UNKNOWN }) | add ) |
  .start = [25,25] |
  .steps = 0 |
  .position = .start |
  .direction = $N |
  .i = 0 |

  INTCODE::readIn(.direction) |

  while(
    .halted | not;
    INTCODE::step |
    .draw = false |
    # if .i == 200 then .halted = true else . end |
    if .output then
      .i += 1 |
      .draw = true |
      if .grid[coords(.position)] != $BLOCKED then
        .grid[coords(.position)] = $FREE
      else
        .
      end |
      .direction as $dir |
      if .output == $WALL then
        .grid[coords(.position)] = $ROBOT |
        .grid[coords(.position | move($dir))] = $WALL |
        forceTurning | INTCODE::readIn(.direction)
      else
        .direction as $dir |
        .position = (.position | move($dir)) | # update the current position of where the robot is

        if .output == $OXYGEN_TANK then
          .halted = true |
          .grid[coords(.position)] = $OXYGEN_TANK
        else
          .grid[coords(.position)] = $ROBOT |
          tryTurning |
          INTCODE::readIn(.direction)
        end
      end
    else
      .
    end
  )
;

# set to true to watch robot moving around
if false then
  $memory | run | .grid[coords(.start)] = $START | if .draw then .grid | PIXELS::paint(["█"," ","x","▒", "░", "o", "S", "⸬"]) else empty end
else
  [$memory | run] |
  last |
  findPathBack |
  .grid[coords(.start)] = $START |
  [.steps, (.grid | PIXELS::paint(["█"," ","x","▒", "░", "o", "S", "⸬"]))][]
end
