# parse and ignore the 2nd part
[
  inputs |
  select(contains("-")) |
  split("-") |
  map(tonumber) |
  sort
] |

# sort so we can find overlaps
sort_by(first) |

# process
reduce .[] as $_ (
  [];
    if $_[0] <= last[1] + 1 then
    # overlap
    .[:-1] + [[
      last[0],
      if $_[1] > last[1] then $_[1] else last[1] end
    ]]
  else
    . + [$_]
  end
)

# dump the answer
| map(last + 1 - first) | add