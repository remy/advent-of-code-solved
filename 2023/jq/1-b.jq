def nums: "zero|one|two|three|four|five|six|seven|eight|nine";
def from_numbers: . as $_ | nums | split("|") | index($_);
def strip_letters: gsub("[a-z]"; "");
def re: "(?<x>\(nums))";
def re_replace: "\(.x | from_numbers)";

# get input, remove numbers, convert text to numbers
[inputs] |
map(
  [
    (sub("\(re).*"; re_replace) | strip_letters[0:1]),
    (sub(".*\(re)"; re_replace) | strip_letters[-1:])
  ] |
  join("") |
  tonumber
) | add

