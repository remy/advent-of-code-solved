def dd: true;
def debug(n): . as $_ | if dd then n | debug end | $_;

def toCoord($w; $h; $i):
  { x: ($i % $w), y: (($i / $h) | floor) }
;

def getPixel($i):
  .grid[$i]
;

def inc: .ptr = .ptr + 1;

def findNext:
  until (
    (.grid[.ptr] == "X") or (.ptr == .length);
    inc
  )
;

def filterValidScan:
  . as $_ |
  .scan | map(select($_.ptr + . | . >= 0 and . < $_.length))
;

def searchFor:
  . as $_ |
  toCoord(.w; .h; .ptr) as $coord |
  filterValidScan as $scan |

  reduce range(0;$scan | length) as $i (
    0;
    if $_.grid[$_.ptr + $scan[$i]] == "M" then
      if $_.grid[$_.ptr + $scan[$i]*2] == "A" then
        if $_.grid[$_.ptr + $scan[$i]*3] == "S" then
          . + 1
        end
      end
    end
  )
;

[inputs/""] | {
  grid: flatten,
  o: .,
  w: .[0] | length,
  h: length,
  ptr: 0,
  ctr: 0,
} |
. + {
  length: .grid | length,
  scan: [1, .w+1, .w, .w-1, -1, -.w -1, -.w, -.w+1]
} |
until(
  .ptr == .length;
  findNext |
  .ctr = .ctr + searchFor |
  .ptr = .ptr + 1
) | .ctr