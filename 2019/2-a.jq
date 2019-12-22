
split(",") | map(tonumber) as $list |
[range(0; $list | length; 4)] | label $out | foreach .[] as $i (
  $list; # arg1
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
  if .[$i+4] == 99 then .[0] else empty end # arg3
)
