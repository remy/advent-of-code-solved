def log(arg): . as $_ | [arg] | debug | $_;
def log: debug;

def arrayFromIndex($i): map(.[$i]);
def tidyOutput: del(.boards) | del(.shadow) | del(.draw) | del(.incompleteBoards);


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

def getCompletedBoards:
  [
    foreach range(.shadow | length) as $board (
      .;
      .;
      foreach range(.shadow[$board] | length) as $row (
        .;
        .;
        if (
          (.shadow[$board][$row] | add) == 5 or
          (.shadow[$board] | arrayFromIndex($row) | add) == 5) then
          $board
        else
          empty
        end
      )
    )
  ] | unique
;

def checkBoard:
  # 1. get a list of board ids that have completed lines
  reduce getCompletedBoards[] as $completed (
    .;
  # 2. loop through the list, ignoring ones that are already complete
    if .incompleteBoards[$completed] == 0 then
  # 3. mark as complete and capture id
      addWinningBoardInfo($completed)
    else
      .
    end
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
  [foreach .draw[] as $draw (
    .;
    .drawn = $draw| markBoards($draw) | checkBoard;
    if (.incompleteBoards | map(select(. == 0)) | length) == 0 then
      error(.) # early exit
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
