def log(s): . as $_ | [s] | debug | $_;
def repeat(n): . as $_ | reduce range (0; n) as $i (""; . + $_);
def dumpStack:
  . as $stack | length as $width | transpose |
  [foreach .[] as $var (""; $var | map("[\(. // " ")]") | join(" "); .)] | reverse | (.[0] | length) as $width | join("\n") | "\n\(.)\n\("-" | repeat($width))"
;
def debugDump:
  . as $_ |
  dumpStack as $res |
  $res | map(debug) | $_;


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
  . as $_ |
  .moves | map(parseMove) |
  reduce .[] as $move (
    $_.stack; # initial state
    (.[$move.from][-$move.n:] | reverse) as $target | # copy
    .[$move.from] = .[$move.from][:-$move.n] | # remove
    .[$move.to] += $target # add
    ) | $_ + { stack: .}
;

parse |
parseStack as $stack |
. + { stack: $stack } |
processMoves |
.stack | map(.[-1]) | join("")
