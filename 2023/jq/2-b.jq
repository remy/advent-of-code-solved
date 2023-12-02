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
  ) |
  map(
    reduce .hands[] as $hand (
      {};
      {
        red: (if $hand.red > .red then $hand.red else .red end),
        green: (if $hand.green > .green then $hand.green else .green end),
        blue: (if $hand.blue > .blue then $hand.blue else .blue end),
      }
    ) | reduce to_entries[] as $_ (1; $_.value * .)
  ) | add
