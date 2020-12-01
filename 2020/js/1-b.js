const readFile = require('fs').readFileSync;

const file = readFile(__dirname + '/../1.input', 'utf-8')
  .split('\n')
  .filter((_) => _.trim())
  .map((_) => parseInt(_, 10));

const length = file.length;
const res = [];

for (let i = 0; i < file.length; i++) {
  const a = file[i];

  if (a > 2018) continue;

  const subset1 = file.slice(1);
  for (let j = 0; j < subset1.length; j++) {
    const b = subset1[j];

    if (a + b > 2020) continue;

    const subset2 = subset1.slice(1);
    for (let k = 0; k < subset2.length; k++) {
      const c = subset2[k];

      if (a + b + c === 2020) {
        res.push(a, b, c);
        break;
      }
    }

    if (res.length) break;
  }
  if (res.length) break;
}

console.log(res.reduce((acc, curr) => (acc *= curr)));
