split(",") | map(tonumber) as $memory |

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
        log1("waiting for input") | del(.memory) | halt_error |
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

def coords(c): c | join(",");

def rotate($angle):
  .robotDir as $R |
  .robotCoords |

  if $R == 0 then
    # if $angle == 0 then
      # .[0] -= 1
    # else
      .[1] -= 1
    # end
  elif $R == 90 then
    # if $angle == 0 then
      # .[1] -= 1
    # else
      .[0] += 1
    # end
  elif $R == 180 then
    # if $angle == 0 then
      # .[0] += 1
    # else
      .[1] += 1
    # end
  else # $R == 270 then
    # if $angle == 0 then
      # .[1] += 1
    # else
      .[0] -= 1
    # end
  end
;

def paint:
  . as $pixels |
  keys | map(split(",") | map(tonumber)) as $coords | $coords |
  [max_by(.[0])[0] + 1, max_by(.[1])[1] + 1] as [$width, $height] |

  def getXY($i): coords([$i % $width, ($i / $width) | floor]);

  reduce range(0; $width * $height) as $i ([];
    . as $_ |
    if $pixels[getXY($i)] == 1 then
      . + ["█"]
    else
      . + ["░"]
    end
  ) | . as $res |

  reduce range(0; $width) as $i (
    "";
    . + ($res[$i * $width: ($i * $width) + $width] | join("") + "\n")
  )
;

def run:
  . as $memory |
  init(0) | readIn(1) |
  .robotDir = 0 |
  .robotCoords = [0,0] |
  .ship = {} |

  until(
    .halted;
    step(.ptr) |
    if .output != null then
      .ship[coords(.robotCoords)] = .output |
      .output = null |

      until(
        .output or .halted;
        step(.ptr)
      ) |

      if .output == 0 then # left 90 deg
        .robotDir = (.robotDir - 90) % 360 |
        if .robotDir < 0 then
          .robotDir = 270
        else
          .
        end
      else # right 90 deg
        .robotDir = (.robotDir + 90) % 360
      end |
      log1("painted: \(["black", "white"][.ship[coords(.robotCoords)]]) @ \(coords(.robotCoords))") |
      .robotCoords = rotate(.output) |
      log1("move to: \(coords(.robotCoords)) R: \(.robotDir)") |
      readIn(.ship[coords(.robotCoords)] // 0)
      | log1("input", .input, .ship)
    else
      .
    end
  ) | .ship
;

# $memory | run

{
  "0,0": 0,
  "1,0": 1,
  "1,1": 1,
  "2,1": 0,
  "2,0": 1,
  "3,0": 1,
  "3,1": 0,
  "4,1": 1,
  "4,0": 0,
  "5,0": 0,
  "5,1": 0,
  "6,1": 1,
  "6,0": 1,
  "7,0": 0,
  "7,1": 0,
  "8,1": 0,
  "8,0": 0,
  "9,0": 0,
  "9,1": 0,
  "10,1": 0,
  "10,0": 0,
  "11,0": 0,
  "11,1": 1,
  "12,1": 0,
  "12,0": 1,
  "13,0": 1,
  "13,1": 0,
  "14,1": 1,
  "14,0": 0,
  "15,0": 0,
  "15,1": 0,
  "16,1": 0,
  "16,0": 1,
  "17,0": 1,
  "17,1": 0,
  "18,1": 0,
  "18,0": 1,
  "19,0": 1,
  "19,1": 1,
  "20,1": 0,
  "20,0": 0,
  "21,0": 0,
  "21,1": 1,
  "22,1": 0,
  "22,0": 1,
  "23,0": 1,
  "23,1": 0,
  "24,1": 1,
  "24,0": 0,
  "25,0": 0,
  "25,1": 0,
  "26,1": 0,
  "26,0": 0,
  "27,0": 0,
  "27,1": 0,
  "28,1": 0,
  "28,0": 1,
  "29,0": 1,
  "29,1": 1,
  "30,1": 0,
  "30,0": 0,
  "31,0": 1,
  "31,1": 1,
  "32,1": 0,
  "32,0": 0,
  "33,0": 0,
  "33,1": 0,
  "34,1": 0,
  "34,0": 0,
  "35,0": 0,
  "35,1": 0,
  "36,1": 0,
  "36,0": 1,
  "37,0": 1,
  "37,1": 0,
  "38,1": 0,
  "38,0": 1,
  "39,0": 1,
  "39,1": 1,
  "40,1": 0,
  "40,0": 0,
  "41,0": 0,
  "41,1": 0,
  "42,1": 0,
  "42,2": 0,
  "41,2": 0,
  "41,3": 0,
  "40,3": 0,
  "40,2": 0,
  "39,2": 0,
  "39,3": 0,
  "38,3": 0,
  "38,2": 1,
  "37,2": 0,
  "37,3": 1,
  "36,3": 0,
  "36,2": 0,
  "35,2": 0,
  "35,3": 0,
  "34,3": 0,
  "34,2": 0,
  "33,2": 0,
  "33,3": 0,
  "32,3": 0,
  "32,2": 0,
  "31,2": 1,
  "31,3": 1,
  "30,3": 0,
  "30,2": 0,
  "29,2": 1,
  "29,3": 1,
  "28,3": 0,
  "28,2": 0,
  "27,2": 0,
  "27,3": 0,
  "26,3": 0,
  "26,2": 0,
  "25,2": 0,
  "25,3": 0,
  "24,3": 0,
  "24,2": 0,
  "23,2": 0,
  "23,3": 0,
  "22,3": 0,
  "22,2": 0,
  "21,2": 1,
  "21,3": 1,
  "20,3": 0,
  "20,2": 0,
  "19,2": 0,
  "19,3": 0,
  "18,3": 0,
  "18,2": 1,
  "17,2": 0,
  "17,3": 1,
  "16,3": 0,
  "16,2": 0,
  "15,2": 0,
  "15,3": 0,
  "14,3": 0,
  "14,2": 0,
  "13,2": 0,
  "13,3": 0,
  "12,3": 0,
  "12,2": 0,
  "11,2": 1,
  "11,3": 1,
  "10,3": 0,
  "10,2": 0,
  "9,2": 0,
  "9,3": 0,
  "8,3": 0,
  "8,2": 0,
  "7,2": 0,
  "7,3": 0,
  "6,3": 1,
  "6,2": 1,
  "5,2": 0,
  "5,3": 0,
  "4,3": 1,
  "4,2": 0,
  "3,2": 1,
  "3,3": 0,
  "2,3": 0,
  "2,2": 1,
  "1,2": 1,
  "1,3": 1,
  "0,3": 0,
  "0,4": 0,
  "1,4": 1,
  "1,5": 1,
  "2,5": 1,
  "2,4": 0,
  "3,4": 0,
  "3,5": 1,
  "4,5": 0,
  "4,4": 1,
  "5,4": 0,
  "5,5": 0,
  "6,5": 1,
  "6,4": 1,
  "7,4": 0,
  "7,5": 1,
  "8,5": 1,
  "8,4": 0,
  "9,4": 0,
  "9,5": 1,
  "10,5": 0,
  "10,4": 0,
  "11,4": 1,
  "11,5": 0,
  "12,5": 1,
  "12,4": 0,
  "13,4": 0,
  "13,5": 1,
  "14,5": 0,
  "14,4": 1,
  "15,4": 0,
  "15,5": 0,
  "16,5": 1,
  "16,4": 1,
  "17,4": 0,
  "17,5": 1,
  "18,5": 1,
  "18,4": 0,
  "19,4": 0,
  "19,5": 1,
  "20,5": 0,
  "20,4": 0,
  "21,4": 1,
  "21,5": 0,
  "22,5": 1,
  "22,4": 0,
  "23,4": 0,
  "23,5": 1,
  "24,5": 0,
  "24,4": 1,
  "25,4": 0,
  "25,5": 0,
  "26,5": 0,
  "26,4": 1,
  "27,4": 0,
  "27,5": 1,
  "28,5": 1,
  "28,4": 0,
  "29,4": 1,
  "29,5": 0,
  "30,5": 0,
  "30,4": 0,
  "31,4": 1,
  "31,5": 1,
  "32,5": 1,
  "32,4": 0,
  "33,4": 0,
  "33,5": 1,
  "34,5": 1,
  "34,4": 0,
  "35,4": 0,
  "35,5": 0,
  "36,5": 1,
  "36,4": 1,
  "37,4": 0,
  "37,5": 1,
  "38,5": 1,
  "38,4": 0,
  "39,4": 0,
  "39,5": 1,
  "40,5": 0,
  "40,4": 0
} | paint
