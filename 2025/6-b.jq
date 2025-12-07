def log(s): . as $_ | [s] | debug | $_;
def mul: reduce .[] as $_ (1; . * $_);
def calc($op): if $op == "+" then add else mul end;

# parse
[inputs | split("";null) | map(select(. != ""))] |

[length, first | length] as [$length, $width] |

. as $_ |

# loop backwards through the column
# (i.e. the characters on the line)
reduce range($width - 1; -1; -1) as $i (
  [];
  . as $state |

  # get the column of numbers
  [
    range($length) |
    $_[.][$i]
  ] |
  . as $output |

  # if the last character is * or +
  if (["*", "+"] | contains([$output | last])) then
    # collect the operator
    $output[-1] as $op |

    # collect all the previous numbers
    ($state | map(type) | index("number")) as $offset |

    # subtract $length - 1 array items
    # then put those with current output and calc
    $state[:$offset] +
    (
      [$state[$offset:] +
      [
        $output[:-1] |
        join("") |
        trim |
        tonumber
      ] |
      [. as $_ | try calc($op) catch error({ i: $i, length: $length, width: $width, output: $output, dot: $_ })]]
    )

  # else if the column is empty, just return state
  elif ($output | join("") | trim) == "" then
    $state

  # else we're going to collect these numbers
  else
    $state + [$output | join("") | trim | tonumber]
  end

) | flatten | add