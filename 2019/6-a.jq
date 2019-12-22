def slurp: [split("\n")[] | select(. != "")];

def load(key):
  . as $_ |
  reduce .[key?][] as $curr (
    {};
    . + { ($curr): ($_ | load($curr)) }
  )
;

slurp | map(split(")")) | reduce .[] as [$p, $o] (
  {};
  . + { ($p): (.[$p] + [$o]) }
) | load("COM") | [paths] | add | length

