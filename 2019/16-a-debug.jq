16 as $length |

def pattern1($n):
  [
    ([0] | combinations($n)),
    ([1] | combinations($n)),
    ([0] | combinations($n)),
    ([-1] | combinations($n))
  ] | add[:$length]
;

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

[pattern1(5), pattern2(5), pattern3(5)]
