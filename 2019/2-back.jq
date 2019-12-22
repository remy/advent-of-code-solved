
# init
split(",") | map(tonumber) |
. as $list |

$list[0] = 100 |

def fn:
  $list[.?] as $type |
  if $type is or $type == 99 then
    empty
  else
    $list[$list[. + 1]] as $a |
    $list[$list[. + 2]] as $b |
    $list[. + 3] as $c |
    # [$a, $b, $c, $list[$c], $a + $b] | debug |
    $list |
    if $type == 99 then
      empty
    elif $type == 1 then
      .[$c] = $a + $b
    elif $type == 2 then
      .[$c] = $a * $b
    else
      "Should not happen \($type) @ \(.)" | halt_error
    end
  end
  # | debug
;

# fn($list)
[range(0; $list | length; 4)] | map(
  . | fn
) | $list
