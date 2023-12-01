[inputs] | map(sub("[a-z]";"";"g") | (if . == "" then "0" else . end) as $n | "\($n[0:1])\($n[-1:])" | tonumber) | add
