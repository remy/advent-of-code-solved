def toRule:
	split(" ") | {
    letter: .[1],
    min: .[0] | split("-")[0] | tonumber,
		max: .[0] | split("-")[1] | tonumber
	}
;

def parse:
	split("\n")[:-1] |
	map(split(": ") | {
    password: .[1],
    rule: .[0] | toRule
	})
;

def test:
	. as $_ |
	.password | split("") as $password |
	[ $password[$_.rule.min - 1], $password[$_.rule.max - 1] ] | indices($_.rule.letter) | length == 1

;

parse | map(select(test)) | length
