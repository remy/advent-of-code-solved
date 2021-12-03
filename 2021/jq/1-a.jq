[foreach range(length) as $i (.; .; if .[$i-1] < .[$i] then .[$i] else empty end)] | length
