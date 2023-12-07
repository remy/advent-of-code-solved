def product: reduce .[] as $_ (1; . * $_);

# this is stupid maths, but it does the trick
def to_strength: if . == 25 then 7 elif . == 16 then 6 elif . == 24 then 5 elif . == 9 then 4 elif . == 6 then 3 elif . == 4 then 2 else 1 end;

def get_hand_strength: length as $len | to_entries | map(.value) | unique | product * (6 - $len) | to_strength;

def strength: .["1"] as $joker |
  if $joker then
	# remove the joker
	(del(.["1"]) | to_entries | sort_by(.value) | reverse | max_by(.value) | .key // "E") as $key |
    del(.["1"]) + { $key: (.[$key] + $joker) }
  end;

def to_hand: . + {
  strength: (.hand | reduce split("")[] as $c ({}; .[$c] = .[$c]+1) )
} | . + { value: (.strength | strength | get_hand_strength) };


{
  A: "E",
  K: "D",
  Q: "C",
  J: "1",
  T: "A",
} as $replace |

[inputs  | gsub("(?<c>[AKQJT])"; "\($replace[.c])")] |
map(split(" ") |
{ hand: .[0], bid: .[1] | tonumber }) |
map(to_hand) |
group_by(.value) |
map(sort_by(.hand)) |
flatten |
. as $input |
reduce range(0; length) as $i (
  0;
  . + ($input[$i].bid * ($i+1))
)
