def log(arg): . as $_ | [arg] | debug | $_;
def log: debug;
def parse: rtrimstr("\n") | split("\n") | map(split("") | map(tonumber));
def arrayFromIndex($i): map(.[$i]);
def count($v): map(select(. == $v)) | length;
def mostSig: [count(0), count(1)] | if .[0] > .[1] then 0 else 1 end;
def leastSig: [count(0), count(1)] | if .[0] > .[1] then 1 else 0 end;
def fromBinary:
	reverse | . as $_ |
	reduce range(length) as $i (
      0;
      if $_[$i] == 1 then
        . + pow(2; $i)
      else
        .
      end
	)
;
def findRating(op): [foreach range(first | length) as $i (
  .;
  (arrayFromIndex($i) | op)  as $sig |
  map(select(.[$i] == $sig))
  ;
  if length == 1 then . else empty end
)] | first | first;

parse | [(findRating(mostSig) | fromBinary), (findRating(leastSig) | fromBinary)] | .[0] * .[1]
