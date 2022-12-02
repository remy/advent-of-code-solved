import { readFileSync } from 'fs';

const map = {
  A: -1, // rock
  B: -2, // paper
  C: -3, // scissors
  X: 1, // rock
  Y: 2, // paper
  Z: 3, // scissors
};

const scoring = new Map([
  [-1, 0],
  [0, 3],
  [1, 6],
]);

const file = readFileSync('2022/2.input', 'utf-8')
  .split('\n')
  .filter(Boolean)
  .map((_) => _.split(' ').map((_) => map[_]))
  .map((_) => {
    let result = _[0] + _[1];

    // this feels janky, but it doesn't really
    // matter if it makes the right solution
    if (result === -2) result = 1;
    if (result === 2) result = -1;

    const score = scoring.get(result);

    return _[1] + score;
  })
  .reduce((acc, curr) => curr + acc, 0);

console.log(file);
