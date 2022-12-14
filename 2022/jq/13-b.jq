def parse: .+"[[2]]\n[[6]]\n" | split("\n") | map(select(. != "") | fromjson);

def compareList:
  def compare:
    . as [$left, $right] |
    if ($left | type == "array") and ($right | type == "array") then
      transpose | compareList
    elif $left == null then
      1
    elif $right == null then
      -1
    elif $left | type == "array" then
      [$left, [$right]] | compare
    elif $right | type == "array" then
      [[$left], $right] | compare
    elif $left == $right then
      0
    elif $left < $right then
      1
    else
      -1
    end
  ;
  reduce .[] as $_ (0;
    if . == 0 then
      $_ | compare
    else . end
  )
;

def sorter:
  . as $input |
  reduce range(0; length) as $i (
    .;
    if $i > (length - 2) then
      .
    else
      [nth($i, $i+1)] as [$left, $right] |
      ([$left, $right] | transpose | compareList) as $sort |
      if $sort == -1 then
        .[0:$i] + [$right, $left] + .[$i+2:]
      else . end
    end
  ) |
  if . != $input then
    sorter
  else
    .
  end
;

parse | sorter | map(tostring)  | reduce indices("[[2]]","[[6]]")[] as $n (1; . * ($n + 1))
