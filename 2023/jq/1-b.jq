def nums: "one|two|three|four|five|six|seven|eight|nine";
def from_numbers(nums): . as $_ | "zero|\(nums)" | split("|") | index($_);
def get_num: match("[0-9]").string;

(nums | split("") | reverse | join("")) as $reversed_nums |

# get input, remove numbers, convert text to numbers
[inputs] |
map(
  . as $_ |
  [
    $_ | sub("(?<x>\(nums))"; "\(.x | from_numbers(nums))"),
    ($_ | split("") | reverse | join("")) | sub("(?<x>\($reversed_nums))"; "\(10 - (.x | from_numbers($reversed_nums)))")
  ] | map(get_num) | join("") | tonumber
) | add

