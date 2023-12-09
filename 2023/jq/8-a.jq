def to_map: [match("([A-Z]{3})"; "g").captures | map(.string) | add] | { "\(.[0])": { L: .[1], R: .[2] } };

def nextStep: . as $_ | (.step + 1) % ($_.route | length);

(input | split("")) as $route | (input | empty), ([inputs | to_map] | add) as $map | {
  route: $route,
  step: 0,
  map: $map,
  pos: "AAA"
} | [while (
  .pos != "ZZZ";
  . + {
    pos: .map[.pos][.route[.step]],
    step: nextStep
  }
)] | length
