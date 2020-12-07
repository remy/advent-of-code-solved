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
  #debug | . as $_ |
  if . == "shiny gold" then
    [0]
  else
    $all.source[.?] |
    map(
      .name |
      if . == "shiny gold" then
        1
      elif $all.source[.] | length == 0 then
        0
      else
        hasBag($all)
      end
    )
  end
  # | [., $_] | debug | .[0]
;


def count:
	{ source: ., count: 0 } as $all |
	to_entries | map(.key) | # array of keys
	map(hasBag($all)) | map(select(flatten | add > 0) | 1) | add
;

parse | add | count
