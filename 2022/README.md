# 2022

These are my entries into the [advent of code 2022](https://adventofcode.com/2022) using the "language" [jq](https://stedolan.github.io/jq/) (not a language at all, but a command line JSON processor!).

## Solved

Below include live demos to the solutions that you can edit and see the results change in real time.

- Day 1 [part 1](https://jqterm.com/ff764509777096eb5a92fc89baa13547?query=split%28%22%5Cn%5Cn%22%29%20%7C%20map%28split%28%22%5Cn%22%29%20%7C%20map%28tonumber%3F%29%20%7C%20add%29%20%7C%20max&slurp=true&raw-input=true), [part 2](https://jqterm.com/ff764509777096eb5a92fc89baa13547?query=split%28%22%5Cn%5Cn%22%29%20%7C%20map%28split%28%22%5Cn%22%29%20%7C%20map%28tonumber%3F%29%20%7C%20add%29%20%7C%20sort%5B-3%3A%5D%20%7C%20add&slurp=true&raw-input=true)
