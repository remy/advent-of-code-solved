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
  	. + [$diff]
  end
) |
first as $first |
map(
  (. * $first >= 0) and
  (abs > 0) and
  (abs < 4)
) | map(select(.)) | length >= ($length - 2)
] | map(select(.)) | length