def every(condition):
  reduce .[] as $item (true; . and ($item | condition));

[inputs |
split(" ") |
map(tonumber) |
length as $length |
. as $_ |
reduce range(0; $length) as $i (
  [];
  if ($i < ($_ | length-1)) then
  	($_[$i] - $_[$i+1]) as $diff |
  	. + [
  		if (($diff | abs) < 4) and (($diff | abs) > 0) then
  			$diff
  		else
  			empty
  		end]
  end
) | . as $_ | every(($_ | length == $length-1) and (. * $_[0]) > 0)] | map(select(.)) | length