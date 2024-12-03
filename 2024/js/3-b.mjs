import { promises as fs } from 'node:fs';
const input = await fs.readFile('./3.sample', 'utf8');
const lines = input.trim().replace('\n', '');

let res = 0;
let Do = true;

lines.replace(
  /(do(?:n't)*\(\))|(mul\((\d{1,3}),(\d{1,3}))\)/g,
  (m, _1, _2, a, b) => {
    if (m.startsWith('do')) {
      Do = true;
      if (m.startsWith('don')) Do = false;
      return;
    }
    if (!Do) return;
    console.log(a, b);
    res += parseInt(a, 10) * parseInt(b, 10);
  }
);

console.log(res);
