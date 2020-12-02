## Running jq code

In nearly all examples, both the raw (`-R`) and slurp (`-s`) flags are used:

```
$ jq -s -R -f [n]-[a/b].jq [n].input
```

If the command doesn't work, then remove the `-R` flag and it should.

For example, day 6 might be:

```
$ jq -s -R -f 6-b.jq 6.input
> 523
```

Each day has `a` and `b` files for each part of the problem. Each day (so far) also has an `.input` file.

In some cases where I needed to better understand the shape of the problem, I create prototype test files to complement the puzzle, and I tend to use that as the basis for my solution.
