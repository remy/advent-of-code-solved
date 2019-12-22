split(",") | map(tonumber) as $prog |
19690720 as $target |

def generate:
  . as $a | [range(0; $a) | . as $i | range(0; $a) | [$i, .]]
;

def run:
  . as $prog |
  # [.[1], .[2]] | debug | $prog |
  [range(0; $prog | length; 4)] | label $out | foreach .[] as $i (
    $prog; # arg1
    if .[$i] == 99 then
      break $out
    else
      .[$i: $i + 4] as [$op, $a, $b, $c] |
      if $op == 1 then
        .[$c] = .[$a] + .[$b]
      elif $op == 2 then
        .[$c] = .[$a] * .[$b]
      else
        "Should not happen \($op) @ \($i)" | halt_error
      end
    end; # arg2
    if .[$i + 4] == 99 then . else empty end
  )
;

[99 | label $out | foreach generate[] as $test (
  $prog;
  $prog |
  # [$test, $target] | debug | $prog | debug |
  .[1] = $test[0] |
  .[2] = $test[1] |
  run
  # | debug
  ;
  if .[0] == $target then [.[1], .[2]] else empty end
)] | last


