8 as $length |

def pattern1($n):
  [
    ([0] | combinations($n)),
    ([1] | combinations($n)),
    ([0] | combinations($n)),
    ([-1] | combinations($n))
  ] | add[:$length]
;

def repeat($n):
	. as $_ |
	length as $len |
	[
		range($n) |
		reduce . as $_ (
          $_[. % $len];
          .
		)
	]
;


def pattern0($n):
  if $n == 1 then 0 else 1 end | . as $start |
  [0,1,0,-1] | [foreach range(0; $n) as $i (.; .; .)] | transpose | flatten[$start:$length + 1] | repeat($length)
;


def pattern0: pattern0(1);

def pattern2($n):
  { n: $n, res: [], source: [0, 1, 0, -1], i: 0 } | until(
    (.res | length) == $length;
    .res += [.source[ (.i / $n | floor) % 4 ]] |
    .i += 1
  ).res
;

def pattern3($n):
  [0,1,0,-1] | [foreach range(0; $n) as $i (.; .; .)] | transpose | flatten[:$length]
;

# [pattern0(1)]
. | rtrimstr("\n")
