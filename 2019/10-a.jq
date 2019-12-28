# "......#.#.
# #..#.#....
# ..#######.
# .#.#.###..
# .#..#.....
# ..#....#.#
# #..#....#.
# .##.#..###
# ##...#..#.
# .#....####" |

def log(s): . as $_ | [s] | debug | $_;

def toCoord(w; h; i):
  { x: (i % w), y: ((i / h) | floor) }
;

def parse:
  split("\n") | map(select(. != "") | split("")) as $rows | $rows[0] as $cols | { w: $cols | length, h: $rows | length, rows: $rows }
;

def tan(a; b):
  { coord: b, atan2: atan2(a.x - b.x; a.y - b.y) | tostring, hypot: hypot(a.x - b.x; a.y - b.y) }
;

def eachPoint($origin):
  . as { $w, $h, $ rows} |
  $rows | reduce range(0; $w * $h) as $i ({};
    toCoord($w; $h; $i) as $point |
    $point as { $x, $y } |

    if $rows[$y][$x] == "#" then
      tan($point; $origin) as $res |
      # log("res", $res, $res.atan2, $res.hypot) |
      if $res.hypot != 0 and .[$res.atan2] < $res.hypot then
        . + { "\($res.atan2)": $res.hypot }
      else
        .
      end
    else
      .
    end
  )
;

parse |
. as $origin |
. as { $w, $h, $ rows} |

$rows | reduce range(0; $w * $h) as $i ([];
  . as $_ | toCoord($w; $h; $i) as { $x, $y } |

  if $rows[$y][$x] == "#" then
    . + [{ coords: "\($x),\($y)", count: $origin | eachPoint({ x: $x, y: $y }) | length }]
  else . end
) | max_by(.count)
