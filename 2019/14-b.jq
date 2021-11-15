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

split("\n") |
map(select(. != "") | parse) |
. + [{ ORE: { required: 0, from: []} }] | # add missing ORE
add | # convert array to object
.inventory = (keys | map({ (.): 0 }) | add) | # add inventory
. as $start |

def makesTrillion:
  . as $n | $start | calcReaction("FUEL"; $n).ORE.required > 1000000000000
;

# only using the searchPow method takes about 16 seconds, combining with
# the binary search solves in around 5 seconds.
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
  if .inc == 0 then
    $top
  else
    while(
      .i | makesTrillion | not;
      .i += .inc
    ) | .i
  end
;

1 | [. | searchPow] | # get the initial range

debug |
until(
  length == 1;
  [. | .[-2:] | searchBin] # then do a binary search until we're narrow enough
)[]
