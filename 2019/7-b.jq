split(",") | map(tonumber) as $memory |
# [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
# -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
# 53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10] as $memory |
0 as $devel |

def log(level; s): . as $_ | if $devel > level then [s] | debug else 0 end | $_;
def log(s): log(9; s);
def log1(s): log(0; s);
def log2(s): log(1; s);

def padLeft(n; value): . as $_ | [range(0; n - length)] | reduce .[] as $i ($_; value + .);

def padLeft(n): padLeft(n; "0");

def param(i): tostring | padLeft(5) | split("")[:-2][3 - i] | tonumber;

def opcode:
  tostring | padLeft(5) | split("")[-2:] | map(tonumber | select(. > 0)) | join("") | tonumber
;

def iff(condition; ptr; list):
  if ptr == null then
    null
  elif condition == 0 then
    list[ptr]
  else
    ptr
  end
;

def call:
  . as $_ |
  if .op == 99 then
    .halted = true
  else
    if .op == 1 then # add
      .memory[.args[2]] = .args[0] + .args[1] |
      log("add", .memory[.args[2]], .args[0], "+", .args[1])
    elif .op == 2 then # multiply
      .memory[.args[2]] = .args[0] * .args[1] |
      log("mul", .memory[.args[2]], .args[0], "*", .args[1])
    elif .op == 3 then # input
      if .input[0] then
        .memory[.args[2]] = .input[0]
        | .input = .input[1:] # "shift"
      else
        .ptr = .ptr - 2 # back up the pointer and wait
      end
    elif .op == 4 then # output
      . + { output: .args[0], lastOutput: .args[0] } |
      log1("output", .output, .name)
    elif .op == 5 then # jump-if-true
      log("jump-if-true", .args[0] > 0, "\(.args[0]) > 0, ptr: \(.args[1])") |
      if .args[0] > 0 then
        .ptr = .args[1]
      else
        .
      end
    elif .op == 6 then # jump-if-false
      log("jump-if-false", .args[0] == 0, .args[1]) |
      if .args[0] == 0 then
        .ptr = .args[1]
      else
        .
      end
    elif .op == 7 then # less than
      log("less than", .args[0] <.args[1]) |
      .memory[.args[2]] = if .args[0] < .args[1] then 1 else 0 end
    elif .op == 8 then # equals
      log("equals") |
      .memory[.args[2]] = if .args[0] == .args[1] then 1 else 0 end
    else
      "Unknown opcode: \(.op)" | halt_error
    end
  end
;

def step($ptr):
  $ptr as $originalPtr |
  . as $_ |
  .memory as $memory |
  $memory[$ptr] as $oc |
  $oc | opcode as $op |

  if $op == 99 then
    log2("> EXIT step @ loop", $_.name, .)
  elif [5,6] | contains([$op]) then
    $ptr + 3
  elif [1,2,7,8] | contains([$op]) then
    $ptr + 4
  elif [3,4] | contains([$op]) then
    $ptr + 2
  else
    "Unknown opcode:\($op) @ \($ptr)" | halt_error
  end |

  if $op != 99 then
    # map memory position to params
    [ ., $memory[$ptr + 1: .] ] | . as [ $ptr, [$a, $b, $c] ]

    # now map to structured program
    | $_ + {
      ptr: $ptr,
      op: $op,
      args: [
        iff($oc | param(1); $a; $memory),
        iff($oc | param(2); $b? // null; $memory),
        $c // $a
      ],
      output: null, # reset output
      memory: $memory
    }
    | call # execute the opcode
  else
    $_ | .halted = true
  end
;

def readIn($input):
  if $input != null then
    .input += [$input] | log2("new input", .input)
  else
    .
  end
;

def init(id):
  {
    halted: false,
    name: [id + 65] | implode,
    id: id,
    ptr: 0,
    op: 0,
    args: [],
    input: [],
    output: null,
    memory: .,
  }
;

def runACS($phase):
  # generate the 5 Amps and pass in the initial phase value
  [range(0; 5)] as $indices |
  $indices | map(
    . as $id |
    $memory |
    init($id) |
    readIn($phase[$id]) |
    if $id == 0 then readIn(0) else . end
  ) as $amps |

  def previous($id): if $id == 0 then 4 else $id - 1 end;

  def run(i):
    .amps as $previous |
    .amps | map(
      if $previous[previous(.id)].output and $previous[previous(.id)].halted == false then
        readIn($previous[previous(.id)].output)
      else
        .
      end |

      step(.ptr)
    )
  ;

  { amps: $amps, i: 0 } |
  until(
    (.amps | last.halted);
     .amps = run(.i) | .i = .i + 1
  ).amps | last | del(.memory)
;

def main:
  # generate all 3125 permutations of [5 x 5] then filter out duplicate numbers
  ["\( range(5;10) ),\( range(5;10) ),\( range(5;10) ),\( range(5;10) ),\( range(5;10) )" | split(",") | map(tonumber)] | map(select(unique | length == 5)) | . as $phases |

  reduce $phases[] as $phase (
    { max: 0, phase: [] };
    . as $_ |
    runACS($phase).lastOutput as $result |
    if $result > .max then
      { max: $result, phase: $phase }
    else
      .
    end
  )
;

main

# runACS([9,7,8,5,6])
