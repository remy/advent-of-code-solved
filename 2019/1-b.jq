map([recurse(. / 3 | floor - 2; . > 0)][1:] | add) | add
