module { name: "intcode advent of code 2019" };

include "./log" { search:"./" };

def padLeft(n; value): . as $_ | [range(0; n - length)] | reduce .[] as $i ($_; value + .);

def padLeft(n): padLeft(n; "0");

def param(i): tostring | padLeft(5) | split("")[:-2][3 - i] | tonumber;

def opcode:
  tostring | padLeft(5) | split("")[-2:] | map(tonumber | select(. > 0)) | join("") | tonumber
;

def iff(memory; mode; ptr; op; read):
  iff(memory; mode; ptr; op; read; .base)
;

def iff(memory; mode; ptr; op; read; base):
  if ptr == null then
    null
  else
    if read and op != 3 then
      # log("get", { mode: mode, ptr: ptr, op: op, base: base, read: read }) |
      if mode == 0 then
        memory[ptr] // 0
      elif mode == 1 then
        ptr
      else
        memory[ptr + base] // 0
      end
    else
      # log("set", { mode: mode, ptr: ptr, op: op, base: base, read: read }) |
      if mode == 0 then
        ptr
      else
        base + ptr
      end
    end
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
      log("mul", .memory[.args[2]], "@ \(.args[2])", .args[0], "*", .args[1])
    elif .op == 3 then # input
      if .input[0] then
        .memory[.args[0]] = .input[0] |
        log2("input \(.input[0]) @ \(.args[0])", .)
        | .input = .input[1:] # "shift"
      else
        log1("waiting for input") | .error = "waiting for input" | del(.memory) | halt_error |
        .ptr = .ptr - 2 # back up the pointer and wait
      end
    elif .op == 4 then # output
      . + { output: .args[0], lastOutput: .args[0] } |
      # log1("output", .output, .name)
      .
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
      log("less than \(.args[0]) < \(.args[1]) = \(.args[0] < .args[1]) in \(.args[2])") |
      .memory[.args[2]] = if .args[0] < .args[1] then 1 else 0 end
    elif .op == 8 then # equals
      log("equals \(.args[0]) == \(.args[1]) = \(.args[0] == .args[1])") |
      .memory[.args[2]] = if .args[0] == .args[1] then 1 else 0 end
    elif .op == 9 then # change base
      .base += .args[0] |
      log("base to \(.base) (from +\(.args[0]))")
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
  log("ptr", $ptr, $oc) |
  $oc | opcode as $op |
  log("oc: \($oc) | opcode: \($op)") |
  if $op == 99 then
    log2("> EXIT step @ loop", $_.name, .)
  elif [5,6] | contains([$op]) then
    $ptr + 3
  elif [1,2,7,8] | contains([$op]) then
    $ptr + 4
  elif [3,4,9] | contains([$op]) then
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
      oc: $oc,
      op: $op,
      abc: [$a, $b, $c],
      args: [
        iff($memory; $oc | param(1); $a; $op; true; $_.base),
        iff($memory; $oc | param(2); $b // null; $op; true; $_.base),
        iff($memory; $oc | param(3); $c // null; $op; false; $_.base) // $a
        # $c // iff($oc | param(3); $c? // null; $memory; $_.base) // $a
      ],
      output: null, # reset output
      memory: $memory
    }
    | log("state", .) | call | log("exit call")# execute the opcode
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
    base: 0,
    memory: .,
  }
;
