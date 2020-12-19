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
  { dir: "E", x: 0, y: 0, waypoint: { x: 10, y: 1 } };
  if $curr.dir == "L" or $curr.dir == "R" then
    . as $_ |
    reduce range(0; $curr.n / 90) as $i (
      .;
      if $curr.dir == "L" then
        .waypoint = { x: -.waypoint.y, y: .waypoint.x }
      else # R
        .waypoint = { x: .waypoint.y, y: -.waypoint.x }
      end
    )
  else
    if $curr.dir == "F" then
      .x += (.waypoint.x * $curr.n) |
      .y += (.waypoint.y * $curr.n)
    else
      $curr.dir as $dir |

      if $dir == "E" then
        .waypoint.x += $curr.n
      elif $dir == "W" then
        .waypoint.x -= $curr.n
      elif $dir == "S" then
        .waypoint.y -= $curr.n
      else
        .waypoint.y += $curr.n
      end
    end
  end #| log($curr, .)
) | [.x, .y] | map(fabs) | add
