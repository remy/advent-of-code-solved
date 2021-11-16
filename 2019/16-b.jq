include "./modules/log";

# with thanks to https://github.com/kufii/Advent-Of-Code-2019-Solutions/blob/master/src/solutions/16/index.js

def repeat($n): [. as $_ | range($n) | $_] | flatten;
def getOffset: .[0:7] | tonumber;

rtrimstr("\n") |
getOffset as $offset |
split("") | map(tonumber) |
repeat(10000) |
.[$offset:] |
length as $length |

def calc:
  foreach range((length-1);-1;-1) as $i (
		.;
		.[$i] = (.[$i+1] + .[$i]) %10 ;
		if $i == 0 then . else empty end
	);

{
  input: .,
  i: 0,
  j: 0,
  phase: 0,
  ptr: ($length-1),
  results: [],
} |

until( # loop until
  .i == 100;
  log(.i, .input[:8]) |
  .input = (.input | calc) |
  .i += 1
).input[:8] | map(tostring) | add
