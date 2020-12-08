def log(s): . as $_ | [s] | debug | $_;

def parse:
  rtrimstr("\n") |
  split("\n") |
  map(
    split(" ") |
    { opcode: .[0], opand: .[1] | tonumber, calls: 0 }
  )
;

def nop($opand):
  .
;

def jmp($opand):
  .PC = .PC + $opand
;

def acc($opand):
  .A = .A + $opand
;

def incrementCall:
  . as $_ |
  . + {
    memory: (
      $_.memory |
      setpath(
        [$_.PC];
        $_.memory[$_.PC] + { calls: ($_.memory[$_.PC].calls + 1) }
      )
    )
  }
;

def step: jmp(1);

def run:
  incrementCall |
  .memory[.PC] as $op |
  if $op.calls == 2 then
    .
  else
    if $op.opcode == "nop" then nop($op.opand) | step
    elif $op.opcode == "jmp" then jmp($op.opand)
    elif $op.opcode == "acc" then acc($op.opand) | step
    else halt end |
    run
  end
;

parse | {
  halt: false,
  memory: .,
  A: 0,
  PC: 0,
} | run.A
