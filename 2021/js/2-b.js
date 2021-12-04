const input = require('fs').readFileSync('../2.input', 'utf8');

const res = input
  .split('\n')
  .filter(Boolean)
  .reduce(
    (acc, _) => {
      let [dir, value] = _.split(' ');
      value = parseInt(value, 10);

      if (dir === 'forward') {
        acc.hpos += value;
        acc.depth += value * acc.aim;
      } else if (dir === 'down') {
        acc.aim += value;
      } else {
        acc.aim -= value;
      }

      return acc;
    },
    {
      hpos: 0,
      depth: 0,
      aim: 0,
    }
  );

res.hpos * res.depth; // ?
