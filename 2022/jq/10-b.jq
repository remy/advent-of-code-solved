def log(s): . as $_ | if [s] | length > 0 then [s] | debug else empty end | $_;
def log(s): .; # this let's me turn logging on and off easily

def parse:
  split("\n") |
  map(
    select(. != "") |
    split(" ") |
    { op: .[0], opand: (if length > 1 then .[1] | tonumber else null end) } )
;

def cycles: { addx: 2, noop: 1 };

def initState:
  {
    prog: .,
    halted: false,
    next: null,
    nextIn: 0,
    ptr: 0,
    ticks: 0,
    totalTicks: . | map(cycles[.op]) | add,
    reg: { x: 1 },
    memory: [],
    crt: [],
    cycles: cycles
  }
;

def getSprite($beam):
  if $beam == .reg.x then
    "#"
  elif $beam == (.reg.x - 1) then
    "#"
  elif $beam == (.reg.x + 1) then
    "#"
  else
    "."
  end
;

def updateCRT:
  ((.ticks - 1) / 40 | floor) as $line |
  (.crt[$line] | length) as $beam |
  .crt[$line] += [getSprite($beam)]
;

def process:
  if .nextIn == 0 then
    .next = .prog[.ptr] |
    .ptr += 1 |
    .nextIn = .cycles[.next.op]
  else
    .
  end |

  .nextIn = (.nextIn - 1) |

  .ticks += 1 |

  updateCRT |

  if .nextIn == 0 then
    if .next.op == "addx" then
      # log("perform op", .reg.x, .next.opand, .reg.x + .next.opand) |
      .reg.x += .next.opand
    else . end
  else . end |

  .halted = (.ticks == .totalTicks)
;

def repeatN($n): . as $_ | [range(0; $n)] | map($_) | join("");
def clear: "\n" | repeatN(38);

def run:
  ## no point data vis!
  # foreach range(0; .totalTicks) as $i (
  #   .;
  #   process;
  #   (.crt | flatten) as $crt |
  #   reduce range (0; 40 * 6) as $i (
  #     [];
  #     . + [$crt[$i] // "."] |
  #     if (($i+1) % 40 == 0) then . + ["\n"] else . end
  #   ) | join("") | "\(clear)\(.)"
  # )
  until(
    .halted;
    process
  )
;

log("==============================") |

parse | initState | log(del(.prog)) | run
| .crt | map(join("")) | join("\n")
