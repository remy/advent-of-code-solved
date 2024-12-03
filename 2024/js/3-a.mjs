import { promises as fs } from 'node:fs';
const input = await fs.readFile('./3.sample', 'utf8');
const lines = input.trim().replace('\n', '');

let res = 0;

lines.replace(/mul\((\d{1,3}),(\d{1,3})\)/g, (_, a, b) => {
  res += parseInt(a, 10) * parseInt(b, 10);
});

console.log(res);
