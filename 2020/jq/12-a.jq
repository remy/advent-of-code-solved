def log(s): . as $_ | [s] | debug | $_;

def parse:
  rtrimstr("\n") | split("\n") | map(
    split("") | {
      dir: .[0],
      n: .[1:] | join("") | tonumber
    }
  )
;

{ L: "NWSE" | split(""), R: "SWNE" | split("") } as $rotate |

def getDir($dir):
  if $dir == "F" then
    .dir
  else
    $dir
  end
;

def rotate($dir):
  . as $_ |
  $rotate[$dir] | $rotate[$dir][(index($_.dir) + 1) % 4]
;

parse | reduce .[] as $curr (
  { dir: "E", x: 0, y: 0 };
  if $curr.dir == "L" or $curr.dir == "R" then
    reduce range(0; $curr.n / 90) as $i (
      .;
      .dir = rotate($curr.dir)
    )
  else
    getDir($curr.dir) as $dir |

    if $dir == "E" then
      .x += $curr.n
    elif $dir == "W" then
      .x -= $curr.n
    elif $dir == "S" then
      .y += $curr.n
    else
      .y -= $curr.n
    end
  end #| log($curr, .)
) | .x + .y
