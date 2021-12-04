def log(arg): . as $_ | [arg] | debug | $_;
def log: debug;

def arrayFromIndex($i): map(.[$i]);

def buildBoards:
  reduce map(split(" ") | map(select(length > 0) | tonumber))[] as $row (
    { boards: [], curr: 0 };
    if $row | length > 0 then
      .boards[.curr] += [$row]
    else
      .curr += 1
    end
  ) | .boards
;

def addShadow: .shadow = (.boards | map(map(map(0)))) ;

def markBoards($draw):
  (.boards | map(map(
    index($draw)
  ))) as $found | .shadow = (
    reduce range($found | length) as $i (
      .shadow;
      reduce range($found[$i] | length) as $j (
        .;
        if $found[$i][$j] == null then . else
          .[$i][$j][$found[$i][$j]] = 1
        end
      )
    )
  )
;

def checkBoard:
  . as $_ |
  foreach range($_.shadow | length) as $boardIndex (
    .;
    foreach range($_.shadow[$boardIndex] | length) as $row (
      $_.shadow[$boardIndex];
      if (.[$row] | add) == 5 then
        $_ | . + { winningBoard: $boardIndex } | error
      elif ($_.shadow[$boardIndex] | arrayFromIndex($row) | add) == 5 then
        $_ | . + { winningBoard: $boardIndex } | error
      else .
      end;
      empty
    );
    empty
  )
;

def collectUnmarked:
  . as $_ |
  # find the winning board
  reduce range(.shadow[.winningBoard] | length) as $col (
    0;
    reduce range($_.shadow[$_.winningBoard][$col] | length) as $row (
      .;
      if $_.shadow[$_.winningBoard][$col][$row] == 0 then
        . + $_.boards[$_.winningBoard][$col][$row] |
        .
      else . end
    )
  )
;

def play:
  foreach .draw[] as $draw (
    .;
    .drawn = $draw | markBoards($draw);
    try checkBoard catch error(.) | . # error allows me to exit the loop early
  )
;

rtrimstr("\n") | split("\n") | {
  draw: .[0] | split(",") | map(tonumber),
  boards: .[2:] | buildBoards
} | addShadow | try play catch . | .drawn * collectUnmarked
