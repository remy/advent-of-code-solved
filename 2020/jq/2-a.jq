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
	.password | split("") | map(select(. == $_.rule.letter)) | length as $count |
	if $count >= $_.rule.min and $count <= $_.rule.max then
		true
    else
		false
	end
;

parse | map(select(test)) | length
