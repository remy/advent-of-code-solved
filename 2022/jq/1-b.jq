split("\n\n") | map(split("\n") | map(tonumber?) | add) | sort[-3:] | add
