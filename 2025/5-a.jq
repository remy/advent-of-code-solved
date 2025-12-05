# parse
[inputs] | join("\n") | split("\n\n") |
{
  range: .[0] | split("\n") | map(split("-") | map(tonumber)),
  inputs: .[1] | split("\n") | map(tonumber)
} |
. as $_ |

# find
.inputs | map(select(
  . as $n |
  $_.range | any($n >= .[0] and $n <= .[1])
)) | length
