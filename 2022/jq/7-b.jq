def log(s): . as $_ | [s] | debug | $_;
def parse: split("\n") | map(select(. != ""));
def parseLine:
	split(" ") |
	if .[0] == "dir" then
		{ file: "\(.[1])", contents: {}, type: "dir" }
	else
		{ file: "\(.[1])", size: .[0] | tonumber, type: "file" }
	end
;

def cd($path):
  if $path == ".." then
    .pwd = .pwd[:-1] # pop
  else
    .pwd += [$path] |
    setpath(.pwd; { _files: [] })
  end
;

def doCommand($cmd):
	if ($cmd | startswith("$ cd")) then
		($cmd | split(" ") | .[2]) as $path |
    cd($path)
	elif $cmd | startswith("$ ls") then
    .
	else
    ($cmd | parseLine) as $res |
    if $res.type == "file" then
      (getpath(.pwd + ["_files"]) + [$res]) as $res |
      setpath(.pwd + ["_files"]; $res)
    else . end
	end
;

def buildTree($fs):
  reduce .[] as $line (
    $fs; # initial state
    doCommand($line)
  )
;

def calc:
  walk(
    if type == "object" and ._files? then
     ._size = ([..] | map(select(._files?)._files | map(.size) | add))
    else . end
  )
;

def totals:
  [..] | map(select(._size?)._size | add)
;

{ "/": {}, "pwd": ["/"] } as $fs |
70000000 as $total |
30000000 as $min |
parse[1:] | buildTree($fs) |
calc |
totals |
sort |
($total - last) as $available |
map(select(
  ($available + .) > $min
)) | first
