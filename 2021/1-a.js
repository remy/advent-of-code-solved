const input = require('fs').readFileSync('./1.input', 'utf8');

input
  .split('\n')
  .map((_) => parseInt(_, 10))
  .filter((value, i, array) => {
    return value > array[i - 1];
  }).length; // ?
