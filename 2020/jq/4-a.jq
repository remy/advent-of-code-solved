def parse:
	split("\n\n") | map(gsub("\n"; " ") | split(" ") | map(split(":") | { (.[0]): .[1] }) | add)
;

def validate:
	if length < 7 then
		empty
	elif length == 7 then
		has("cid") | not
	else
		.
	end
;

parse | map(select(validate)) | length
