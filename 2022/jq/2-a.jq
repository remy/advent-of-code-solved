def values: { A: -1, B: -2, C: -3, X: 1, Y: 2, Z: 3 }[.];

# -2 = win, -1 = lose, 0 = draw, 1 = win, 2 = lose
# so we adjust the values for the scoring
def score:
  add |
  if . == -2 then 1
  elif . == 2 then -1
  else .
  end
;

def scoring: if . < 0 then 0 elif . == 0 then 3 else 6 end;

split("\n") |
map(
  select(. != "") | # filter empty
  split(" ") | # get left and right
  map(values) | # convert to scoring
  .[1] + (score | scoring)
) | add
