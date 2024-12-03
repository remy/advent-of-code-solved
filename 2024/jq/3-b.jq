def debug(n): . as $_ | n | debug | $_;

[
  [inputs] |
  join("") |
  match("(do(?:n't)*)\\(\\)|(mul)\\((\\d{1,3}),(\\d{1,3})\\)"; "g")
] |

{
  input: map(
    .captures |
    if .[0].string == "don't" then
      false
    elif .[0].string == "do" then
      true
    elif .[1].string == "mul" then
      (.[2].string | tonumber) * (.[3].string | tonumber)
    else
      debug | empty
    end
  ),
  do: true,
  total: 0
} | [foreach .input[] as $_ (.;
  if $_ == true then
    .do = true
  elif $_ == false then
    .do = false
  elif .do then
    .total += $_
  else
    .
  end;
  .total)] | last

