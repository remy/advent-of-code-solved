# 2019

These are my entries into the [advent of code 2019](https://adventofcode.com/2019) using the "language" [jq](https://stedolan.github.io/jq/) (not a language at all, but a command line JSON processor!).

In all cases, except day 1, the command to run is:

```
$ jq -s -R -f [n]-[a/b].jq [n].input
```

Day 1 doesn't require the `-R` (raw-input) arg.

For example, day 6 is:

```
$ jq -s -R -f 6-b.jq 6.input
> 523
```

Each day has `a` and `b` files for each part of the problem. Each day (so far) also has an `.input` file.

In some cases where I needed to better understand the shape of the problem, I've created `.js` files to complement the puzzle, and I tend to use that as the basis for my solution.
