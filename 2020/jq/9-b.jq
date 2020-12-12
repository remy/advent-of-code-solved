def log(s): . as $_ | [s] | debug | $_;

def n: 25;

def search($source; $target):
  2 | until(
    $source[0:.] | add |
    if . > $target then error("break")
    elif . == $target then true
    else false end
    ;
    . + 1
  ) | $source[0:.]
;

def part2($target):
  length as $length |
  . as $source |
  0 | until(
    try (search($source[.:$length]; $target) | true) catch . < $length;
    . + 1
  ) | search($source[.:$length]; $target) | [min,max] | add
;

def part1:
  # part 1 repeated to get source value
  def loop2($j; $needle; $limit):
    .j = $j |
    until(
      .j == $limit or .res == true;
      if .source[.i] + .source[.j] == $needle then
        .res = true
      else
        .
      end |
      .j = .j + 1
    )
  ;

  def loop1($limit; $needle):
    until(
      .i == $limit or .res == true;
      loop2(.i + 1; $needle; $limit) | .i = .i + 1
    )
  ;

  . as $source |

  # emit a trailing slice of n of the array
  [range(n; length)] | until (
    .[0] |
    $source[.] as $v |
    {
      source: $source[. - n: .],
      i: 0,
      j: 0,
      res: false
    } |
    loop1(.source | length; $v).res | not;
    .[1:]
  ) | $source[first]
;

part2(part1)
