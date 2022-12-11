def log(s): . as $_ | if [s] | length > 0 then [s] | debug else empty end | $_;
def log(s): .; # this let's me turn logging on and off easily

def parseOpParam:
    if . == "old" then .
    else tonumber end;

def parseMonkey: split("\n") | map(select(. != "")) | {
  id: .[0] | split("Monkey ")[1][:-1] | tonumber,
  items: .[1] | split("Starting items: ")[1] | split(", ") | map(tonumber),
  op: .[2] | split("Operation: new = ")[1] | split(" ") | [
    (.[0] | parseOpParam),
    .[1],
    (.[2] | parseOpParam)
  ],
  inspections: 0,
  test: {
    div: .[3] | split("Test: divisible by ")[1] | tonumber,
    true: .[4] | split("throw to monkey ")[1] | tonumber,
    false: .[5] | split("throw to monkey ")[1] | tonumber
  }

};

def parse: split("\n\n") | map(parseMonkey);

def inspectItem($monkey):
  . as $old |
  $monkey.op as [$x, $op, $y] |
  (if $x == "old" then $old else $x end) as $x |
  (if $y == "old" then $old else $y end) as $y |
  if $op == "*" then
    ($x * $y) % $monkey.base
  else #elif $op == "+" then
    $x + $y
  end
;

def whoToThrowTo($monkey):
  if . % $monkey.test.div == 0 then
    $monkey.test.true
  else
    $monkey.test.false
  end
;

def moveItems($i; $items; $move):
  setpath([$i, "items"]; $items) |
  map(
    $move["\(.id)"] as $toMove |
    if $toMove then
      .items += $toMove
    else
      .
    end
  )
;

def monkeyAround:
  [foreach range(0; length) as $i (
    .;
    .[$i] as $monkey |
    (.[$i].items | length) as $nInspections |
    (reduce .[$i].items[] as $item (
      { items: [], move: {} };
      ($item | inspectItem($monkey)) as $item |
      ($item | whoToThrowTo($monkey)) as $who |
      if $who != $monkey.id then
        if .move["\($who)"] then
          .move += { "\($who)": (.move["\($who)"] + [$item]) }
        else
          .move += { "\($who)": [$item] }
        end
      else
        .items += [$item]
      end
    )) as { $items, $move } |

    moveItems($i; $items; $move) |
    setpath([$i, "inspections"]; .[$i].inspections + $nInspections)
    ;
    .
  )] | last
;

def addDivisableBase:
  (reduce .[] as $x (1; $x.test.div * .)) as $base |
  map(.base = $base)
;

log("=======================") |
parse |
addDivisableBase |
reduce range(0; 10000) as $i (
  .;
  monkeyAround
) |
map({ id, inspections, items }) |
sort_by(.inspections)[-2:] | .[0].inspections * .[1].inspections
