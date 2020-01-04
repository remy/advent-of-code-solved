include "./modules/log";
import "./modules/intcode" as INTCODE;

split(",") | map(tonumber) as $memory |

def coords(c): c | join(",");

def rotate($angle):
  .robotDir as $R |
  .robotCoords |

  if $R == 0 then
    .[1] -= 1
  elif $R == 90 then
    .[0] += 1
  elif $R == 180 then
    .[1] += 1
  else # $R == 270 then
    .[0] -= 1
  end
;

def paint:
  . as $pixels |
  keys | map(split(",") | map(tonumber)) as $coords | $coords |
  [max_by(.[0])[0] + 1, max_by(.[1])[1] + 1] as [$width, $height] |

  def getXY($i): coords([$i % $width, ($i / $width) | floor]);

  reduce range(0; $width * $height) as $i ([];
    . as $_ |
    if $pixels[getXY($i)] == 1 then
      . + ["█"]
    else
      . + ["░"]
    end
  ) | . as $res |

  reduce range(0; $height) as $i (
    "";
    . + ($res[$i * $width: ($i * $width) + $width] | join("") + "\n")
  )
;

def run:
  . as $memory |
  INTCODE::init(0) | INTCODE::readIn(1) |
  .robotDir = 0 |
  .robotCoords = [0,0] |
  .ship = {} |

  until(
    .halted;
    INTCODE::step(.ptr) |
    if .output != null then
      .ship[coords(.robotCoords)] = .output |
      .output = null |

      until(
        .output or .halted;
        INTCODE::step(.ptr)
      ) |

      if .output == 0 then # left 90 deg
        .robotDir = (.robotDir - 90) % 360 |
        if .robotDir < 0 then
          .robotDir = 270
        else
          .
        end
      else # right 90 deg
        .robotDir = (.robotDir + 90) % 360
      end |
      log("painted: \(["black", "white"][.ship[coords(.robotCoords)]]) @ \(coords(.robotCoords))") |
      .robotCoords = rotate(.output) |
      log("move to: \(coords(.robotCoords)) R: \(.robotDir)") |
      INTCODE::readIn(.ship[coords(.robotCoords)] // 0)
    else
      .
    end
  ) | .ship | paint
;

$memory | run

