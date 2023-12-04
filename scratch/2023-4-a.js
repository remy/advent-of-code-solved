/* eslint-env node */
const sample = require('fs').readFileSync(
  __dirname + '/../2023/4.sample',
  'utf8'
);

const res = sample
  .split('\n')
  .filter(Boolean)
  .map((line) => {
    const [, numbers] = line.split(':');
    const [win, options] = numbers.split('|').map((_) =>
      _.split(/\s+/)
        .filter(Boolean)
        .map((_) => parseInt(_.trim(), 10))
    );

    const wins = win.reduce((acc, curr) => {
      if (options.includes(curr)) {
        acc++;
      }
      return acc;
    }, 0);

    return wins;
  });
// .reduce((acc, curr) => curr + acc, 0); // ?

const data = Array.from({ length: res.length }).reduce((acc, curr, i) => {
  acc[i] = 1;
  return acc;
}, {});

const result = res
  .reduce((acc, curr, j) => {
    for (let i = j + 1; i < j + curr + 1; i++) {
      acc[i] = acc[i] + acc[j];
    }

    return acc;
  }, Object.values(data))
  .reduce((acc, curr) => curr + acc, 0);

result; // ?
