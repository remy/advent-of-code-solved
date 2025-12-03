import { promises as fs } from 'fs';

const horizontals = (await fs.readFile('2024/4.input', 'utf8'))
  .trim()
  .split('\n');

const MAS = ['MAS', 'MAS'.split('').reverse().join('')];

const vecsize = horizontals.length;
let count = 0;

for (let i = 0; i < vecsize; i++) {
  for (let j = 0; j < vecsize; j++) {
    const char = horizontals[i][j];

    if (char !== 'A') continue;
    if (i - 1 < 0) continue;
    if (i + 1 >= vecsize) continue;
    if (j - 1 < 0) continue;
    if (j + 1 >= vecsize) continue;

    const topleft = horizontals[i - 1][j - 1];
    const topright = horizontals[i - 1][j + 1];
    const bottomleft = horizontals[i + 1][j - 1];
    const bottomright = horizontals[i + 1][j + 1];

    const diag1 = `${topleft}${char}${bottomright}`;
    const diag2 = `${topright}${char}${bottomleft}`;

    if (MAS.includes(diag1) && MAS.includes(diag2)) {
      count += 1;
    }
  }
}

console.log('Appearances:', count);
