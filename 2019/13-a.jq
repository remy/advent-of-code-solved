include "./modules/log";
import "./modules/intcode" as INTCODE;

def coords(c): c | join(",");

split(",") | map(tonumber) as $memory |

def run:
  . as $memory |
  INTCODE::init(0) |

  .game = {} |
  .tmp = [] |

  until(
    .halted;
    INTCODE::step(.ptr) |
    # .stage = (.stage + 1) % 3 |
    if .output then
      .tmp += [.output] |

      if (.tmp | length) == 3 then
        .game[coords(.tmp[:2])] = .tmp[2] |
        .tmp = []
      else
        .
      end
    else
      .
    end
  )
;

$memory | run | .game | [to_entries[].value | select(. == 2)] | length
