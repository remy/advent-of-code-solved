def getNumbers: [match("(\\d+)"; "g")] | map(.captures[0].string | tonumber);
def getMap: (first | split(" ")[0] | split("-") | { from: .[0], to: .[2] }) + {
  map: .[1:] | map(getNumbers | {
    dest: .[0],
    source: .[1],
    range: .[2]
  })
};
def findMap($from; $map): $map.maps | map(select(.from == $from))[];
def getMapping($from; $map):
  . as $_ |
  findMap($from; $map) as $from | $from.map | map(
    select(
      ($_ >= .source) and ($_ < (.source + .range))
    ) | ($_ - .source) + .dest
  )[] // $_
;

[inputs] | {
  seeds: (first | getNumbers),
  maps: .[2:] | join("\n") | split("\n\n") | map(split("\n") | getMap)
} as $map |

# 53 | getMapping("fertilizer"; $map)

reduce ($map.maps|map(.from))[] as $from (
	$map.seeds;
  map(getMapping($from; $map))
) | min
