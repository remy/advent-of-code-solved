module { name: "pixel painter" };

def coords(c): c | join(",");

def paint:
. as $pixels |
keys | map(split(",") | map(tonumber)) as $coords | $coords |
[max_by(.[0])[0] + 1, max_by(.[1])[1] + 1] as [$width, $height] |

def getXY($i): coords([$i % $width, ($i / $width) | floor]);

reduce range(0; $width * $height) as $i ([];
  . as $_ |
  $pixels[getXY($i)] as $v |
  if $v == 0 then # empty
    . + [" "]
  elif $v == 1 then # wall
    . + ["█"]
  elif $v == 2 then # block
    . + ["░"]
  elif $v == 3 then # paddle
    . + ["—"]
  elif $v == 4 then # ball
    . + ["o"]
  else
    .
  end
) | . as $res |

reduce range(0; $height) as $i (
  "";
  . + ($res[$i * $width: ($i * $width) + $width] | join("") + "\n")
)
;
