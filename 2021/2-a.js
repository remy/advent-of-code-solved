const input = require('fs').readFileSync('./2.input', 'utf8');

const res = {
  hpos: 0,
  depth: 0,
};

input
  .split('\n')
  .filter(Boolean)
  .forEach((_) => {
    let [dir, value] = _.split(' ');
    value = parseInt(value, 10);

    if (dir === 'forward') {
      res.hpos += value;
    } else if (dir === 'down') {
      res.depth += value;
    } else {
      res.depth -= value;
    }
  });

res.hpos * res.depth; // ?
