split("\n\n") | map(split("\n") | map(tonumber?) | add) | max
