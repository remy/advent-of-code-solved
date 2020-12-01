def loop3($k):
  .k = $k |
  until(
    .k == 200 or .res != null;
    if .source[.i] + .source[.j] + .source[.k] == 2020 then
      .res = .source[.i] * .source[.j] * .source[.k]
    else
      .
    end |
    .k = .k + 1
  )
;


def loop2($j):
  .j = $j |
  until(
    .j == 200 or .res != null;
    if .source[.i] + .source[.j] > 2019 then
      .
    else
      loop3(.j + 1)
    end | .j = .j + 1
  )
;

def loop1:
  until(
    .i == 200 or .res != null;
    loop2(.i + 1) | .i = .i + 1
  )
;

{
  source: .,
  i: 0,
  j: 0,
  k: 0,
  res: null
} | loop1.res
