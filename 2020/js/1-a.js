const readFile = require('fs').readFileSync;

const file = readFile(__dirname + '/../1.input', 'utf-8')
  .split('\n')
  .filter((_) => _.trim())
  .map((_) => parseInt(_, 10));

const length = file.length;

let a = null;

let b = file.find((n, j) => {
  for (let i = 0; i < file.length; i++) {
    const m = file[i];
    if (i === j) return false;
    if (n + m === 2020) {
      a = m;
      return true;
    }
  }
});

console.log(a * b);
