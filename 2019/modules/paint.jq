module { name: "pixel painter" };

def coords(c): c | join(",");

# @param {string[]} icons: array of printable characters
# @param {string} default: the value to print if no icon available at index
def paint(icons; default):
  . as $pixels |
  keys | map(split(",") | map(tonumber)) as $coords | $coords |
  [min_by(.[0])[0], min_by(.[1])[1]] as [$widthMin, $heightMin] |
  [max_by(.[0])[0] + 1, max_by(.[1])[1] + 1] as [$widthMax, $heightMax] |
  ($widthMax - $widthMin) as $width |
  ($heightMax - $heightMin) as $height |

  def getXY($i): coords([($i % $width) + $widthMin, (($i / $width) | floor) + $heightMin]);

  reduce range(0; $width * $height) as $i ([];
    . as $_ |
    ($pixels[getXY($i)] // default) as $v |
    . + [icons[$v]]
  ) | . as $res |

  reduce range(0; $height) as $i (
    "";
    . + ($res[$i * $width: ($i * $width) + $width] | join("") + "\n")
  )
;

def paint: paint([" ","█","░","—","o"]; 2);
# def paint($pixels): paint($pixels; 2) . as $tmp | $pixels | paint | debug | $tmp;
def paint($pixels): paint($pixels; 2);



