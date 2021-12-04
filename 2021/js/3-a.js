const input = require('fs').readFileSync(__dirname + '/../3.input', 'utf8');

const matrix = input
  .trim()
  .split('\n')
  .map((_) => _.split('').map((_) => parseInt(_, 10)));

const res = Array.from({ length: matrix[0].length }, (_, i) => {
  return matrix.map((_) => _[i]);
}).reduce(
  (acc, curr, i) => {
    const len = curr.length;
    const zero = curr.filter((_) => _ === 0).length;
    const one = curr.length - zero;

    acc.gamma.push(one > zero ? 1 : 0);
    acc.epsilon.push(one > zero ? 0 : 1);

    return acc;
  },
  { gamma: [], epsilon: [] }
); // ?

parseInt(res.gamma.join(''), 2) * parseInt(res.epsilon.join(''), 2); // ?
