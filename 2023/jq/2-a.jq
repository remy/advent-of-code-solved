# limits only 12 red cubes, 13 green cubes, and 14 blue cubes

def possible: .hands | length as $i | map(
  select(
    (.red <= 12) and (.green <= 13) and (.blue <= 14)
  )
) | length == $i;

[inputs] |
  map(
    (capture("Game (?<game>(\\d+)):").game | tonumber) as $gameId | {
      gameId: $gameId,
      hands:
      (split(";") |
        map(
          [capture("(?<count>\\d+) (?<colour>red|blue|green)"; "g")] | to_entries |
          map({
            "\(.value.colour)": .value.count | tonumber
          }) | add)
      )
    }
  ) | map(select(possible).gameId) | add
