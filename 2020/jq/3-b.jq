def parse:
	split("\n") |
	{ trees: map(split("")), width: .[0] | length }
;

def treeRun($source; $dx; $dy):
	{ x: 0, y: 0, collisions: 0 } |

	def run:
		.y = .y + $dy |
		.x = (.x + $dx) % $source.width |
		if $source.trees[.y][.x] == "#" then
			.collisions = .collisions + 1
		else
			.
		end |

    if $source.trees[.y+1] then
			run
		else
			.
		end
	;

	run
;

parse as $source |
[
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2]
] |
map(treeRun($source; .[0]; .[1]).collisions) |
reduce .[] as $n (1; . * $n)
