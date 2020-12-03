def parse:
	split("\n") |
	{ trees: map(split("")), width: .[0] | length }
;

def treeRun($dx; $dy):
	. as $source |
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

parse | treeRun(3; 1)
