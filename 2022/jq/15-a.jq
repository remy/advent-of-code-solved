def log(s): . as $_ | if [s] | length > 0 then [s] | debug else empty end | $_;
#def log(s): .; # this let's me turn logging on and off easily

def scanRow: 10;

def distance($cmp):
  .x as $x1 |
  .y as $y1 |

  $cmp.x as $x2 |
  $cmp.y as $y2 |

  (([$x1,$x2] | sort | (.[1] - .[0])) + ([$y1,$y2] | sort | (.[1] - .[0])))
;


def parse:
  . / "\n" |
  map(match("(-?[0-9]+)"; "g").string | tonumber) as $_ |
  [range(0; $_ | length;4)] |
  map(
    $_[.:.+4] as [$x, $y, $x2, $y2] |
    { $x, $y, $x2, $y2 } | . + { d: distance({ x: $x2, y: $y2 }) }
  );

def findNearestSensor($x; $y):
  .grid | map(
    .d as $d |
    distance({ $x, $y }) as $d2 |

    if $d2 <= .d then
      . + { test: { testPointD: $d2, $d, $x } }
    else
      false
    end

  ) as $result |
  if $result | all(. == false) then
    false
  else
    $result | map(
      select(. != false) |
      .x + (.d - (.y - scanRow)) # wrong
    ) | sort | first
  end
;

log("============================") |

parse |
(map(.x - .d) | min) as $min |
(map(.x + .d) | max) as $max |
# log({$min, $max}) |
{ grid: ., x: $min, $min, max: $max, empty: map(select(.y2 == scanRow)) | unique_by(.x2) | length } |
recurse(
  . as $_ |
  { x: $_.x, y: scanRow } as $point |

  findNearestSensor($point.x; $point.y) as $sensor |

  # log({ $sensor, $point }) |

  if $sensor == false then
    .x += 1 |
    .empty += 1
  else
    # log("jumping from ", .x, ([ $sensor, .x+1 ] | max)) |
    .x = ([ $sensor, .x+1 ] | max) # increment by the width of the sensor
  end
;
  .x < .max + 1
) | .max + (.min | fabs) - .empty

# | last | del(.grid) | log((.max - .min) , (.empty | length)) | .empty


# reduce range($min; ($max + 1)) as $i (
#   [];
#   . + [$input | any(
#     .d as $d |
#     distance({ x: $i, y: $scanRow }) as $d2 |
#     if .x2 == $i and .y2 == $scanRow then
#       false
#     elif $d2 > .d then
#       false
#     else
#       log({$d2, $d, $i, point: .}) |
#       .
#     end
#   )]
# ) | map(if . then 1 else 0 end) | add

