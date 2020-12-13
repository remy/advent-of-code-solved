. as $source |
(max + 3) as $i |

[foreach range(0; length + 1) as $_ (
  { source: $source, next: $i };
  . as $_ | .source | {
    source: map(select(. != $_.next)),
    last: $_.next,
    next: map(select(. != $_.next)) | max
  };
  # .last -
  if .next == null then .last else (.last - .next) end
)] | reduce .[] as $i ({ "1": 0, "3": 0 }; .["\($i)"] = .["\($i)"] + 1 ) | .["1"] * .["3"]
