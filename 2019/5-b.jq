split(",") | map(tonumber) as $prog |
# [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9] as $prog |
5 as $input |
0 as $devel |

def log(s): . as $_ | if $devel > 0 then [s] | debug else 0 end | $_;

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


def call(op; args; ptr):
  log("call", { ptr: ptr, op: op, args: args, _: . }) |
  if op == 99 then
    empty
  else
    if op == 1 then # add
      .[args[2]] = args[0] + args[1]
    elif op == 2 then # mul
      .[args[2]] = args[0] * args[1]
    elif op == 3 then # input
      .[args[2]] = $input # global input
    elif op == 4 then # output
      . as $_ | "output: \(args[0])" | debug | $_
    elif op == 5 then # jump-if-true
      if args[0] > 0 then
        args[1]
      else
        ptr
      end
    elif op == 6 then # jump-if-false
      if args[0] == 0 then
        args[1]
      else
        ptr | log("here noop", .)
      end
    elif op == 7 then # less than
      .[args[2]] = if args[0] < args[1] then 1 else 0 end
    elif op == 8 then # equals
      .[args[2]] = if args[0] == args[1] then 1 else 0 end
    else
      "Unknown opcode: \(op)" | halt_error
    end
  end
;

def parseOp(i):
  . as $_ |
  $_[i] as $oc |
  $oc | opcode as $op |
  $oc | [param(1), param(2)] as [$p1, $p2] |
  if $op == 99 then
    empty
  elif [5,6] | contains([$op]) then
    i + 3
  elif [1,2,7,8] | contains([$op]) then
    i + 4
  elif [3,4] | contains([$op]) then
    i + 2
  else
    "Unknown opcode:\($op) @ \(i)" | halt_error
  end |
  [ ., $_[i + 1: .] ] | . as [ $ptr, [$a, $b, $c] ] |
  {
    ptr: $ptr,
    op: $op,
    args: [
      iff($p1; $a; $_),
      iff($p2; $b? // null; $_),
      $c // $a
    ],
    memory: $_
  } as $program |
  $program |
  # log(.) |
  if [5,6] | contains([$program.op]) then
    $program.ptr = ($program.memory | call($program.op; $program.args; $program.ptr)) | log("ptr update", .ptr)
  else
    $program.memory = ($program.memory | call($program.op; $program.args; $program.ptr))
  end
  | log("call out", .)
;

$prog | parseOp(0) |

[while(.ptr; . as { $memory, $ptr } | $memory | parseOp($ptr))] | last | empty
