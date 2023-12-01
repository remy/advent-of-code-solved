import { readFile } from 'node:fs/promises';

const input = await readFile('./1.input', 'utf8');

const numbers = 'zero|one|two|three|four|five|six|seven|eight|nine';
const re = new RegExp(`(${numbers})`, 'g');
const lines = input
  .trim()
  .split('\n')
  .map((_) => {
    return _.replace(re, (match) => {
      return numbers.split('|').indexOf(match);
    }).replace(/\D/g, '');
  })
  .map((_) => parseInt(`${_[0]}${_.slice(-1)}`, 10))
  .reduce((a, b) => a + b);

console.log(lines);
