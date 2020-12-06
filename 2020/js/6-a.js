const readFile = require('fs').readFileSync;

const file = readFile(__dirname + '/../6.input', 'utf-8')
  .split('\n\n')
  .filter((_) => _.trim());

file.reduce((acc, curr) => {
  acc += new Set(curr.replace(/\s/g, '').split('')).size;
  return acc;
}, 0); // ?
