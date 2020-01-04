def devel: 0;

def log(level; s): . as $_ | if devel > level then [s] | debug else 0 end | $_;
def log(s): log(9; s);
def log1(s): log(0; s);
def log2(s): log(1; s);
