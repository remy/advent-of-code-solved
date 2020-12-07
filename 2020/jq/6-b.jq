def sum:
  reduce .[] as $i (0; . + $i)
;

def mapper:
  reduce .[] as $i (
      {};
    . + { ($i): (.[$i] + 1) }
    )
;

def mergeAndCount:
  length as $count |
  reduce (.[] | to_entries) as $root ({}; . + (
      . as $_ |
      $root | reduce .[] as $item (
      $_;
      . + { ($item.key): ($item.value + .[$item.key]) }
    )
    # this map is the difference
    )) | map(select(. == $count)) | if length > 0 then length else empty end
;

rtrimstr("\n") | split("\n\n") |

map(
  split("\n") | map(
    split("") | mapper
  ) | mergeAndCount
) | sum
