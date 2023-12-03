# collect input
[inputs] as $input |

# create grid and grid info
($input[0] | length) as $width |
($input | length) as $height |

(reduce range(0; $height) as $i (
	[];
	. + ([$input[$i] | match("(?<part>\\d+)"; "g")] | map({ string, offset: (.offset + $i * $width), length }))
)) as $parts |

($input | join("")) as $grid |

def product: reduce .[] as $_ (1; . * $_);
def get_i($x; $y): if $y < 0 then -1 elif $y >= $height then -1 elif $x < 0 then -1 elif $x >= $width then -1 else $width * $y + $x end;
def get_xy($i): { x: ($i % $width), y: ($i / $width | floor) };
def get_ring($p1; $p2):
	{ x: [range($p1.x-1; $p2.x+2)], y: ($p1.y-1) } |
	[., (. + { y: ($p2.y + 1) }), { x: [$p1.x-1, $p2.x + 1], y: $p1.y} ]
;
def get_coords($a; $b): get_ring(get_xy($a); get_xy($a + ($b - 1)));

(reduce range(0; $height) as $i (
	[];
	. + ([$input[$i] | match("\\*"; "g")] | map({ string, offset: (.offset + $i * $width), length }))
) | map(. + get_xy(.offset))) as $gears |


$parts | map(
  . + { coords: get_coords(.offset; .length) } as $part |
  $part.coords |
  map(
    . as $_ |
    .x |
    map(
      get_i(.; $_.y) |
      select(. > -1)
  	)
  ) |
  flatten |
  map(
    $grid[.:.+1] |
    select(test("\\*"))
  ) |
  select(length > 0) |
  $part
) as $points | $gears | map(
  # now find the points that this touches
  . as $gear |
  $points | map(
    . as $point |
    .coords |
    map(
      select(
        (.y == $gear.y) and (.x | bsearch($gear.x) >= 0)
      ) + $point
    )
  ) | flatten | select(length == 2) | map(.string | tonumber) | product
) | add
