def getNumbers: [match("(\\d+)"; "g")] | map(.captures[0].string | tonumber);
def getMap: (first | split(" ")[0] | split("-") | { from: .[0], to: .[2] }) + {
  map: .[1:] | map(getNumbers | {
    dest: .[0],
    from: .[1],
    range: .[2],
    to: (.[1] + .[2] - 1)
  })
};
def findMap($from; $map): $map.maps | map(select(.from == $from))[];
def getMapping($from; $map):
  . as $_ |
  findMap($from; $map) as $from | $from.map | map(
    select(
      (($_.from >= .from) and ($_.from < .to))
    ) |
    if $_.to < .to then
      debug("fits")
    else
      debug("split") # need to find where it's split
    end |
    debug([. ,"|", $_])
    # | ($_.from - .from) + .dest
  )[] // $_
;

[inputs] | {
  seeds: (
    first |
    getNumbers |
    . as $input |
    reduce range(0; length; 2) as $i (
      [];
       . + [{ from: $input[$i], range: $input[$i+1], to: ($input[$i] + ($input[$i+1] - 1))}]
    ) | sort_by(.from)
  ),
  maps: .[2:] | join("\n") | split("\n\n") | map(split("\n") | getMap)
} as $map |

$map
#.seeds | .[0:2] | map(getMapping("seed"; $map))
# 53 | getMapping("fertilizer"; $map)

# reduce ($map.maps|map(.from))[] as $from (
# 	$map.seeds;
#   map(getMapping($from; $map))
# ) | min
