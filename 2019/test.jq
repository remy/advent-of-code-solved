[
  2,
  0,
  4,
  0,
  0,
  0,
  2,
  0,
  99
] |
. as $prog |
length as $length |

def loop(i):
  (.[i] % 100) as $op |
  if $op == 99 then
    "stop in loop" | halt_error
  elif $op == 2 then
    .[i] = "2"
  else
    .[i] = "4"
  end
;

def while(init; cond):
  def _while(i):
    . as $_ |
    i | cond as $next | $_ |
    if $next then
      loop(i) | ., _while($next)
    else
      empty
    end;
  . as $_ | init | _while($_)
;

0 | [while(
  $prog; # init
  . as $_ | # condition
  if . >= ($prog | length) then
    empty
  else
    ($prog[$_] % 100) as $op | { op: $op} | debug |
    if $op == 99 then
      empty
    elif $op > 2 then
      $_ + 4
    else
      $_ + 2
    end
  end
)] | last
