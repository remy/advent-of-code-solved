def parse:
	split("\n\n") | map(gsub("\n"; " ") | split(" ") | map(split(":") | { (.[0]): .[1] }) | add)
;

def btw($min; $max):
	(.value | tonumber) as $value |
	if $value < $min or $value > $max then
		empty
	else
		.
	end
;

def reg($re):
	if .value | match($re) then
		.
	else
		empty
	end
;

def ecl:
	if [.value] | inside(["amb","blu","brn","gry","grn","hzl","oth"]) then
		.
	else
		empty
	end
;

def hgt:
	. as $_ | .value |
	if match("^[0-9]+(cm|in)$") | not then
		empty
	else
		capture("^(?<value>[0-9]+)(?<measure>cm|in)$") |
		if .measure == "cm" and btw(150; 193) then
			$_
		elif .measure == "in" and btw(59; 76) then
			$_
		else
			empty
		end
	end
;

def validateField:
	if .key == "byr" then
		btw(1920; 2002)
	elif .key == "iyr" then
		btw(2010; 2020)
	elif .key == "eyr" then
		btw(2020; 2030)
	elif .key == "hgt" then
		hgt
	elif .key == "hcl" then
		reg("^#[0-9a-f]{6}$")
	elif .key == "pid" then
		reg("^[0-9]{9}$")
	elif .key == "ecl" then
		ecl
	else
		.
	end
;

def validate:
	to_entries | map(validateField) | from_entries | # strip out invalid fields first
	if (length == 8) or (length == 7 and (has("cid") | not)) then
		.
	else
		empty
	end
;

parse | map(select(validate)) | length
