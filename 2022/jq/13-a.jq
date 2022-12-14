def log(s): . as $_ | if [s] | length > 0 then [s] | debug else empty end | $_;
def log(s): .; # this let's me turn logging on and off easily

def parse: split("\n\n") | map(split("\n") | map(select(. != "") | fromjson));

def compareList:
  def compare:
    . as [$left, $right] |
    log("comp", { left: $left, right: $right }) |
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
    log($_, .) |
    if . == 0 then
      $_ | compare
    else . end
  )
   | log("res", .)
;

log("===============") |

parse | map(transpose | compareList) | indices(1) | map(. + 1) | add
