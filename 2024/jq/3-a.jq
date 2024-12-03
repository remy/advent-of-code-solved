[[inputs] | join("") | match("mul\\((\\d{1,3}),(\\d{1,3})\\)"; "g").captures | reduce map(.string | tonumber)[] as $n (1; .*$n)] | add

