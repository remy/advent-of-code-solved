split(",") | map(tonumber) as $prog |
# [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
# 1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0] as $prog |
11 as $devel |

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
  # log("call", .) |
  if .op == 99 then
    empty
  else
    if .op == 1 then # add
      .memory[.args[2]] = .args[0] + .args[1] |
      log("add", .memory[.args[2]], .args[0], "+", .args[1])
    elif .op == 2 then # multiply
      .memory[.args[2]] = .args[0] * .args[1] |
      log("mul", .memory[.args[2]], .args[0], "*", .args[1])
    elif .op == 3 then # input
      .memory[.args[2]] = .input[0]
      | log("input", .input[0])
      | .input = .input[1:] # "shift"
    elif .op == 4 then # output
      . + { output: .args[0] }
      | log("output", .output)
      # | log2("output: \(.output)")
    elif .op == 5 then # jump-if-true
      log("jump-if-true") |
      if .args[0] > 0 then
        .ptr = .args[1]
      else
        .
      end
    elif .op == 6 then # jump-if-false
      log("jump-if-false") |
      if .args[0] == 0 then
        .ptr = .args[1]
      else
        .
      end
    elif .op == 7 then # less than
      log("less than") |
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
  . as $_ |
  .memory as $memory |
  $memory[$ptr] as $oc |
  $oc | opcode as $op |
  if $op == 99 then
    empty
  elif [5,6] | contains([$op]) then
    $ptr + 3
  elif [1,2,7,8] | contains([$op]) then
    $ptr + 4
  elif [3,4] | contains([$op]) then
    $ptr + 2
  else
    "Unknown opcode:\($op) @ \($ptr)" | halt_error
  end

  # map memory position to params
  | [ ., $memory[$ptr + 1: .] ] | . as [ $ptr, [$a, $b, $c] ]

  # now map to structured program
  | {
    ptr: $ptr,
    op: $op,
    args: [
      iff($oc | param(1); $a; $memory),
      iff($oc | param(2); $b? // null; $memory),
      $c // $a
    ],
    input: $_.input,
    output: null, # reset output
    memory: $memory
  }
  | call # execute the opcode
  # | log("step out", .memory)
;

def readIn($input):
  if $input != null then
    .input += [$input] | log2("new input", .input)
  else
    .
  end
;

def init:
  {
    ptr: 0,
    op: 0,
    args: [],
    input: [],
    output: null,
    memory: .
  }
;

def run:
  step(0) |
  [while(
    .ptr;
    readIn(.output) | step(.ptr)
  )] | last | del(.memory)
;

def runACS($phase):
  reduce $phase[] as $setting (
    0;
    . as $thrust |
    $prog | init | readIn($setting) | readIn($thrust) | run | .output
  )
;

def main:
  # generate all 3125 permutations of [5 x 5] then filter out duplicate numbers
  ["\( range(0;5) ),\( range(0;5) ),\( range(0;5) ),\( range(0;5) ),\( range(0;5) )" | split(",") | map(tonumber)] | map(select(unique | length == 5)) | . as $phases |

  reduce $phases[] as $phase (
    { max: 0, phase: [] };
    . as $_ |
    runACS($phase) as $result |
    if $result > .max then
      { max: $result, phase: $phase }
    else
      .
    end
  )
;

main
# runACS([1,1,1,1,1])


