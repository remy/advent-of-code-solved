def parse: split("\n") | map(split("") | map(tonumber));
def arrayFromIndex($i): map(.[$i]);
def count($v): map(select(. == $v)) | length;
def mostSig: if .[0] > .[1] then 0 else 1 end;
def leastSig: if .[0] > .[1] then 1 else 0 end;
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

parse |
[
  foreach range(first | length) as $i (
    .;.;
    arrayFromIndex($i) | [count(0), count(1)]
  )
] | {
  gamma: map(mostSig) | fromBinary,
  epsilon: map(leastSig) | fromBinary
} | .gamma * .epsilon
