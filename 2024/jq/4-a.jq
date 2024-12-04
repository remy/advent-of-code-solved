def toCoord(w; h; i):
  { x: (i % w), y: ((i / h) | floor) }
;

def getPixel(i):
  toCoord(.w; .h; i) as $coord |
  .grid[$coord.y][$coord.x]
;

def search

[inputs/""] | {
  grid: .,
  w: .[0] | length,
  h: length,
  ptr: 0,
  ctr: 0;
} | getPixel(5)