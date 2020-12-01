[combinations(2)] | map(select(.[0] + .[1] == 2020))[0] | .[0] * .[1]
