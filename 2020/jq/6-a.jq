def sum:
	reduce .[] as $i (0; . + $i)
;

def mapper:
	reduce .[] as $i (
      {};
	  . + { ($i): (.[$i] + 1) }
    )
;

# merges group answers and gets the total count
def mergeAndCount:
	reduce (.[] | to_entries[]) as $root ({}; . +
		{ ($root.key): 1 }
	) | length
;

rtrimstr("\n") | split("\n\n") |

map(
  split("\n") | map(
    split("") | mapper
  ) | mergeAndCount
) | sum
