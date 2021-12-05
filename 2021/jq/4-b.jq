def log(arg): . as $_ | [arg] | debug | $_;
def log: debug;

def arrayFromIndex($i): map(.[$i]);
def tidyOutput: del(.boards) | del(.shadow) | del(.draw);


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

def addWinningBoardInfo(boardIndex):
  . + {
    winningBoard: boardIndex,
    incompleteBoards: (.incompleteBoards | .[boardIndex] = 1)
  }
;

def checkBoard:
  . as $_ |
  foreach range($_.shadow | length) as $boardIndex (
    .; # init
    . as $__ | foreach range(.shadow[$boardIndex] | length) as $row (
      $_.shadow[$boardIndex]; # init
      if ((.[$row] | add) == 5) or ((arrayFromIndex($row) | add) == 5)
      then
        if $_.incompleteBoards[$boardIndex] == 0 then
          $_ | addWinningBoardInfo($boardIndex) |
          # log($boardIndex, .drawn, if $boardIndex == 55 then [.shadow[$boardIndex], .boards[$boardIndex]] else empty end) |
          error
        else
          . # already completed, then ignore it
        end
      else
        .
      end; # update
      $__ # extact
    ); # update
    . # extract
  ) | $_
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
  [foreach .draw[] as $draw (
    .;
    .drawn = $draw| markBoards($draw) | try checkBoard catch .;
    if (.incompleteBoards | map(select(. == 0)) | length) == 0 then
      error(.)
    else
      .
    end
  )] | last
;

rtrimstr("\n") | split("\n") | {
  draw: .[0] | split(",") | map(tonumber),
  boards: .[2:] | buildBoards
} | addShadow | . + { incompleteBoards: [range(.boards | length)] | map(0)} |
try play catch . | .drawn * collectUnmarked
