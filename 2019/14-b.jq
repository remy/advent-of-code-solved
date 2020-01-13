include "./modules/log";

def trim: . | sub("[,]"; ""; "g") | ltrimstr(" ") | rtrimstr(" ");
def splitter: trim | split(" ") | map(trim) | [.[1], (.[0] | tonumber)];

def parse:
	split(" => ") as $pair | $pair |
	.[1] | splitter |
	{ (.[0]): { required: 0, output: .[1], from: ($pair[0] | split(",") | map(splitter) ) } }
;

def calcReaction(key; $need):
  .[key] as { $from, $output } |
  reduce $from[] as [$key, $input] (
    .;
    (((($need / $output) | ceil) * $input) - .inventory[$key]) as $needToProduce |
    .[$key].required += $needToProduce |
    (((($needToProduce / (.[$key].output // 1)) | ceil) * (.[$key].output // 1)) - $needToProduce) as $overflow |
    .inventory[$key] = $overflow |
    calcReaction($key; $needToProduce)
  )
;

# "
# 171 ORE => 8 CNZTR
# 7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
# 114 ORE => 4 BHXH
# 14 VRPVC => 6 BMBT
# 6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
# 6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
# 15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
# 13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
# 5 BMBT => 4 WPTQ
# 189 ORE => 9 KTJDG
# 1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
# 12 VRPVC, 27 CNZTR => 2 XDBXC
# 15 KTJDG, 12 BHXH => 5 XCVML
# 3 BHXH, 2 VRPVC => 7 MZWV
# 121 ORE => 7 VRPVC
# 7 XCVML => 6 RJRHP
# 5 BHXH, 4 VRPVC => 5 LTCX
# " |



split("\n") |
map(select(. != "") | parse) |
. + [{ ORE: { required: 0, from: []} }] | # add missing ORE
add | # convert array to object
.inventory = (keys | map({ (.): 0 }) | add) | # add inventory
. as $start |

def makesTrillion:
  . as $n | $start | calcReaction("FUEL"; $n).ORE.required > 1000000000000
  # . == 2944565   or . > 2944565
;

def searchPow:
  { base: ., i: 1 } |
  while(
    (.i + .base) | makesTrillion | not;
    .i *= 2
  ) | .i + .base
;

# binary search is faster than using the log method above
def searchBin:
  . as [$base, $top] |
  { i: $base, inc: (($top - $base) / 2 | floor) } |
  if .inc == 1 then
    $top
  else
    while(
      .i | makesTrillion | not;
      .i += .inc
    ) | .i
  end
;

1 | [. | searchPow] |
until(
  length == 1;
  [. | .[-2:] | searchBin]
)[]
