def parse:
 split(",") | map({ dir: .[:1], n: .[1:] | tonumber })
;

def slurp:
  [split("\n")[] | select(. != "")]
;

def hash:
  map({ "\(.x),\(.y)": 1 }) | add
;

def walk:
  [foreach .[] as $item (
    { x: 0, y: 0 };
    . as $c |
    foreach range(0; $item.n) as $n (
      [];
      if $item.dir == "R" then
        { x: ((.x? // $c.x) + 1), y: (.y? // $c.y) }
      elif $item.dir == "L" then
        { x: ((.x? // $c.x) - 1), y: (.y? // $c.y) }
      elif $item.dir == "U" then
        { x: (.x? // $c.x), y: ((.y? // $c.y) - 1) }
      else # D
        { x: (.x? // $c.x), y: ((.y? // $c.y) + 1) }
      end
    );
    .
  )] | hash
;

def distance(blue):
  reduce to_entries[] as $n (
    [];
    . as $_ |
    if blue[$n.key] then
      $_ + [$n.key]
    else
      $_
    end
  ) | map(split(",") | map(tonumber | length) | add) | sort | first
;

[slurp[] | parse] as $paths | $paths as [$first, $second] | $first | walk as $red | $second | walk as $blue | $red | distance($blue)
