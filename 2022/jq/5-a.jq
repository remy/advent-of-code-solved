def stripEmpty: map(select(. != "" and . != " "));

def parse: split("\n\n") | map(split("\n") | stripEmpty) | { stack: .[0], moves: .[1] };

def getRows($cols):
  . as $stack |
  reduce range (0; $cols * 4; 4) as $i (
    [];
    . + [$stack[$i+1:$i+2]]
  );

def parseStack:
  .stack | reverse as $stack |
  ($stack[0] | split(" ") | stripEmpty | length) as $cols |
  $stack[1:] | map(getRows($cols)) | transpose | map(stripEmpty)
;

def parseMove: split(" ") | { n: .[1] | tonumber, from: (.[3] | tonumber -1), to: (.[5] | tonumber -1) };

def processMoves:
  reduce (.moves | map(parseMove))[] as $move (
    .stack; # initial state
    (.[$move.from][-$move.n:] | reverse) as $target | # copy
    .[$move.from] = .[$move.from][:-$move.n] | # remove
    .[$move.to] += $target # add
  )
;

parse |
. + { stack: parseStack } |
processMoves |
map(.[-1]) |
join("")
