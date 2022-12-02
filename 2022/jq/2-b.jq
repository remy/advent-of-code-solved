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

{ A: "X", B: "Y", C: "Z" } as $draw |
{ A: "Y", B: "Z", C: "X" } as $win |
{ A: "Z", B: "X", C: "Y" } as $lose |

def predict:
	if .[1] == "X" then [.[0], $lose[.[0]]]
	elif .[1] == "Y" then [.[0], $draw[.[0]]]
	else [.[0], $win[.[0]]]
	end
;

split("\n") |
map(
  select(. != "") | # filter empty
  split(" ") | # get left and right
  predict |
  map(values) | # convert to scoring
  score as $win | # capture whether it was win, lose or draw
  .[1] + ($win | scoring)
) | add
