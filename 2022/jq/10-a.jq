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
    cycles: cycles
  }
;

def shouldCollect:
  .ticks as $ticks |
  ([range(20; 220 + 1; 40)] | index($ticks)) != null
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
  log({ ticks: .ticks, x: .reg.x, next: (if .nextIn == 0 then .next else .nextIn end) }) |

  if shouldCollect then
    .memory += [.reg.x * .ticks]
  else . end |

  if .nextIn == 0 then
    if .next.op == "addx" then
      # log("perform op", .reg.x, .next.opand, .reg.x + .next.opand) |
      .reg.x += .next.opand
    else . end
  else . end |

  .halted = (.ticks == .totalTicks)
;

def run:
  until(
    .halted;
    process
  )
;

log("==============================") |

parse | initState | log(del(.prog)) | run
| del(.prog) + { total: .memory | add } | .total
