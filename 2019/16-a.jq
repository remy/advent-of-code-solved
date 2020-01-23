include "./modules/log";


#37153056

# "19617804207202209144916044189917" |

length as $length |

([range(0; $length)] | map(0)) as $p |

def pattern($n):
  [0,1,0,-1] | [foreach range(0; $n) as $i (.; .; .)] | transpose | flatten[:$length]
;


def pattern: pattern(1);

def calc:
  until(
    .input[.ptr] | not;
    .results += [.input[.ptr] * .pattern[(.ptr + 1) % (.pattern | length)]] |
    .ptr += 1
  ).results | add | tostring[-1:] | tonumber
;

split("") | map(tonumber) |

0 as $phase |

{
  pattern: pattern($phase + 1),
  input: .,
  i: 0,
  ptr: 0,
  phase: $phase,
  results: [],
} |

until(
  debug(.i) | .i == 100;
  . as $res |
  .input = reduce range(0; $length) as $i (
    [];
    . + [$res | .pattern = pattern($i + 1) | calc]
  ) |
  .i += 1 |
  .ptr = 0
).input[:8] | map(tostring) | add | tonumber
