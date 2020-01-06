include "./modules/log";
include "./modules/paint";
import "./modules/intcode" as INTCODE;

def coords(c): c | join(",");

split(",") | map(tonumber) as $memory |

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
  .snap = [] |

  until(
    .halted;

    INTCODE::step(.ptr) |
    # .stage = (.stage + 1) % 3 |
    if .output then
      .tmp += [.output] |

      if (.tmp | length) == 3 then
        if .tmp[0] == -1 then
          .score = .tmp[2]
        else
          coords(.tmp[:2]) as $cords |
          .game[$cords] = .tmp[2] |

          if .game[$cords] == 4 and .paddle > -1 then
            .ball = .tmp[0] |
            . as $_ |
            if .ball < .paddle then
              INTCODE::readIn(-1)
            elif .ball > .paddle then
              INTCODE::readIn(1)
            else
              INTCODE::readIn(0)
            end |

            # now count tiles in case the game has ended
            (.game | [to_entries[].value | select(. == 2)] | length) as $bricks |
            # log1("bricks", $bricks, .score) |
            if $bricks == 0 then
              .game | paint | halt_error
            else
              .
            end

            # | .snap = .snap + [(.game | paint)]

          elif .game[$cords] == 3 then
            .paddle = .tmp[0]
            # . as $_ | .game | paint | halt_error | $_
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

$memory | run | "Score: \(.score)\n\n\(.game | paint)"
