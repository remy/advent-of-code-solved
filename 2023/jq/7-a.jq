def product: reduce .[] as $_ (1; . * $_);

# this is stupid maths, but it does the trick
def to_strength: if . == 25 then 7 elif . == 16 then 6 elif . == 24 then 5 elif . == 9 then 4 elif . == 6 then 3 elif . == 4 then 2 else 1 end;

def get_hand_strength: length as $len | to_entries | map(.value) | unique | product * (6 - $len) | to_strength;

def to_hand: . + { strength: (.hand | reduce split("")[] as $c ({}; .[$c] = .[$c]+1) | . + { value: get_hand_strength}) };

{
  A: "E",
  K: "D",
  Q: "C",
  J: "B",
  T: "A",
} as $replace |

[inputs  | gsub("(?<c>[AKQJT])"; "\($replace[.c])")] | map(split(" ") | { hand: .[0], bid: .[1] | tonumber }) | map(to_hand) | group_by(.strength.value) | map(sort_by(.hand)) | flatten | . as $input | reduce range(0; length) as $i (
  0;
  . + ($input[$i].bid * ($i+1))
)
