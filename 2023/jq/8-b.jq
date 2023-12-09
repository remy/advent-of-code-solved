def to_map: [match("([0-9A-Z]{3})"; "g").captures | map(.string) | add] | { "\(.[0])": { L: .[1], R: .[2] } };

def gcd($a; $b):
  if $b == 0 then $a
  else gcd($b; $a % $b)
  end;

def lcm($a; $b):
  ($a * $b) / gcd($a; $b);

[(input | split("")) as $route |
(input | empty),
([inputs | to_map] | add) as $map |
($route | length) as $length |
$map |
to_entries |
map(select(.key[2:3] == "A").key) |
map({
  step: 0,
  ticks: 0,
  pos: .
})[] | until(
  .pos[2:3] == "Z";
  {
    ticks: (.ticks+1),
    pos: $map[.pos][$route[.step]],
    step: ((.step + 1) % $length)
  }
) | .ticks]  | reduce .[] as $n (
  1;
  lcm(.; $n)
)



# while (
#   map(.pos[2:3] == "Z") | all | not;
#   map({
#     ticks: (.ticks+1),
#     pos: $map[.pos][$route[.step]],
#     step: nextStep($length)
#   })
# ) | "\u001b[?25l\(.[0].ticks)\u001b[A\u001b[G"

# # echo -e "\u001b[?25h" # to get cursor back
