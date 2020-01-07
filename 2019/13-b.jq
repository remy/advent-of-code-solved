include "./modules/log";
import "./modules/intcode" as INTCODE;

def coords(c): c | join(",");

split(",") | map(tonumber) as $memory |

def tile:
  if . == 0 then # empty
    " "
  elif . == 1 then # wall
    "█"
  elif . == 2 then # block
    "░"
  elif . == 3 then # paddle
    "▔"
  elif . == 4 then # ball
    "o"
  else
    .
  end
;

def xyToI(width; x; y): width * y + x + y;

def screen:
  .game as $game |
  .game |
  keys |
  map(split(",") | map(tonumber)) as $coords |
  $coords |
  [max_by(.[0])[0] + 1, max_by(.[1])[1] + 1] as [$width, $height] |

  {
    width: $width,
    height: $height,
    data: (reduce range(0; $width * $height) as $i (
      [];
      . + [($game[coords([$i % $width, ($i / $width) | floor])] | tile)]
    ) | . as $res | $res | reduce range(0; $height) as $i (
      [];
      . + ($res[$i * $width: ($i * $width) + $width] + ["\n"])
    ))
  }
;

def run:
  .[0] = 2 | # play for free
  . as $memory |
  INTCODE::init(0) |
  INTCODE::readIn(0) |

  .game = {} |
  .paddle = -1 |
  .ball = 0 |
  .tmp = [] |
  .score = 0 |
  .paint = false |
  .screen = [] |

  while(
    .halted | not;

    INTCODE::step(.ptr) |
    if .output then
      .tmp += [.output] |
      .paint = false |

      if (.tmp | length) == 3 then
        if .tmp[0] == -1 then
          .score = .tmp[2]
        else
          coords(.tmp[:2]) as $cords |
          .game[$cords] = .tmp[2] |

          if .game[$cords] == 4 and .paddle > -1 and .screen == [] then # initialise the screen
            .screen = screen # | .screen.data | halt_error
          elif .screen != [] then
            # update the screen
            # .screen = screen(.tmp)
            .screen as $screen |
            .screen.data[xyToI($screen.width; .tmp[0]; .tmp[1])] = (.tmp[2] | tile) |
            .paint = true
          else
            .
          end |

          if .game[$cords] == 4 and .paddle > -1 then # we're playing
            .ball = .tmp[0] |
            . as $_ |
            if .ball < .paddle then
              INTCODE::readIn(-1)
            elif .ball > .paddle then
              INTCODE::readIn(1)
            else
              INTCODE::readIn(0)
            end
          elif .game[$cords] == 3 then
            .paddle = .tmp[0]
          else
            .
          end
        end |

        .tmp = []
      else
        .
      end
    else
      .
    end
  )
;

$memory | run |
if .paint == true then "\(.screen.data | join(""))\n\(.score)" else empty end
