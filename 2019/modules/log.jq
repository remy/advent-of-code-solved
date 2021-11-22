def devel: 0;

def log(level; s): . as $_ | if devel > level then [s] | debug else 0 end | $_;
def log(s): log(10; s);
def log10(s): log(9; s);
def log1(s): log(0; s);
def log2(s): log(1; s);

def debug(s): log(0; s);
def stop: debug | halt;

# Usage:
# include "./log" { search:"./" };
# . | log("some value", $someVar, .) | .
#
# Change the `devel` value to show different levels of debug:
# `log1` is highest, `log` is lowest - setting `devel` to zero hides output
