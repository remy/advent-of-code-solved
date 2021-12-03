[foreach range(length-2) as $i (.; .; .[$i:$i+3]) | add ] |
[foreach range(length) as $i (.; .; if .[$i-1] < .[$i] then .[$i] else empty end)] | length
