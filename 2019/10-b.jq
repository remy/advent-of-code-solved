# ".#..##.###...#######
# ##.############..##.
# .#.######.########.#
# .###.#######.####.#.
# #####.##.#.##.###.##
# ..#####..#.#########
# ####################
# #.####....###.#.#.##
# ##.#################
# #####.##.###..####..
# ..######..##.#######
# ####.##.####...##..#
# .#####..#.######.###
# ##...#.##########...
# #.##########.#######
# .####.#.###.###.#.##
# ....##.##.###..#####
# .#.#.###########.###
# #.#.#.#####.####.###
# ###.##.####.##.#..##" |

def log(s): . as $_ | [s] | debug | $_;

def toCoord(w; h; i):
  { x: (i % w), y: ((i / w) | floor) }
;

def parse:
  split("\n") | map(select(. != "") | split("")) as $rows | { w: $rows[0] | length, h: $rows | length, rows: $rows }
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
      if $res.hypot == 0 then
        . + { ($res.atan2): { hypot: $res.hypot, count: 0, coords: [] } }
      elif .[$res.atan2].hypot < $res.hypot then
        . + { ($res.atan2): { coords: ([{ x: $x, y: $y }] + .[$res.atan2].coords), hypot: $res.hypot, count: ((.[$res.atan2].count + 1)) } }
      else
        .[$res.atan2].count = (1 + .[$res.atan2].count) |
        .[$res.atan2].coords = (.[$res.atan2].coords + [{ x: $x, y: $y }])
      end
    else
      .
    end
  )
;

parse |
. as $source |
. as { $w, $h, $ rows} |
$rows | reduce range(0; $w * $h) as $i (
  [];
  . as $_ | toCoord($w; $h; $i) as { $x, $y } |

  if $rows[$y][$x] == "#" then
    ($source | eachPoint({ x: $x, y: $y })) as $hits |
    . + [{ coords: { x: $x, y: $y }, hits: $hits, count: $hits | length }]
  else
    .
  end
) | . as $data | sort_by(.count) | last as $origin | $origin.hits | keys | map(tonumber) | sort | reverse | map(tostring) as $points | foreach $data[] as $_ (
  { zero: index("0"), max: length, i: 0, points: $origin.hits };
  .curr = $points[(.i + .zero) % .max] |
  if .points[.curr].count > 0 then
    .points[.curr].count -= 1
  else
    .
  end |
  .i += 1;
  if .i == 200 then .points[.curr].coords[.points[.curr].count] else empty end
) | (.x * 100 + .y)
