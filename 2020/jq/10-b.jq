def log(s): . as $_ | [s] | debug | $_;

def find1($i):
  .[:1] | map(select(. == ($i+1))) | first
;

def find2($i):
  .[:2] | map(select(. == ($i+2))) | first
;

def find3($i):
  .[:3] | map(select(. == ($i+3))) | first
;

log(">>>>>>>>>>>>>>>>>>>>>>") |

sort |
. as $source |
foreach range(0; length) as $i (
  $source[0];
  $source[$i];
  . as $_ | log($_, $i) | $source[$i:] | [find1($_), find2($_), find3($_)]
)
