def trim:
	map(capture("^\\s*(?<value>.*?)\\s*$"; "g") | .value)
;

def parse:
	rtrimstr("\n") |
	gsub("bags?\\.?"; ""; "g") | # clean contents
	split("\n") |
	map(
      split("contain") |
      map(split(",")) |
      flatten |
      trim |
      {
        (.[0]): .[1:] | map(capture("^(?<n>\\d+)\\s(?<name>.*)$") | { n: .n | tonumber, name })
      }
	)
;

def hasBag($all):
  . as $bag |
  $all.source[.] |
  if length > 0 then map(
    . as $_ | .name |
    if $all.source[.] | length then
      hasBag($all) * $_.n + $_.n
    else
      1
    end
  ) else [0] end | add
;

def count:
	{ source: ., count: 0 } as $all |
  "shiny gold" | hasBag($all)
;

parse | add | count
