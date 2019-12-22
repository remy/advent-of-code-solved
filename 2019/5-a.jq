split(",") | map(tonumber) as $prog |
# [1002,4,3,4,33] as $prog |
$prog | length as $length |
1 as $input |

def log(s):
  . as $_ | [s] | debug | $_
;

def padLeft(n; value):
  . as $_ | [range(0; n - length)] | reduce .[] as $i ($_; value + .)
;

def padLeft(n):
  padLeft(n; "0")
;

def param(i):
  tostring | padLeft(5) | split("")[:-2][3 - i] | tonumber
;

def opcode:
  tostring | padLeft(5) | split("")[-2:] | map(tonumber | select(. > 0)) | join("") | tonumber
;

def condition(i):
  . as $prog |
  # log(">COND", i) |
  if i >= ($length - 1) then
    empty
  else
    ($prog[i] % 100) as $op |
    if $op == 99 then
      empty
    elif $op > 2 then
      i + 2
    else
      i + 4
    end
  end
;

# this is the main logic
def loop(i):
  . as $_ |
  $_[i] as $oc |
  $oc | opcode as $op |

  if $op == 99 then
    $_
  elif $op < 3 then
    $oc | [param(1), param(2)] as [$p1, $p2] |
    $_[i + 1: i + 4] as [$a, $b, $c] |
    # { oc: $oc, op: $op, p1: $p1, p2: $p2, _: $_, i: i, a: [$a, $b, $c ] } | log("state") |

    if $op == 1 then
      (if $p1 > 0 then $a else $_[$a] end) + (if $p2 > 0 then $b else $_[$b] end)
    else # $op == 2
      (if $p1 > 0 then $a else $_[$a] end) * (if $p2 > 0 then $b else $_[$b] end)
    end | . as $res | $_ |
    .[$c] = $res
  else
    $oc | param(1) as $p1 |
    $_[i + 1] as $c | $_ |
    if $op == 3 then
      .[$c] = $input
    elif $p1 > 0 then
      { output: $c, info: ["immediate"] } | debug | $_
    else
      { output: .[$c], info: ["ref"] } | debug | $_
    end
  end
;

def while:
  def _while(i):
    if i then # note: if (0) is truthy
      loop(i) |
      condition(i) as $next |
      ., _while($next)
    else
      empty
    end;
  [_while(0)]
;

$prog | while | last

