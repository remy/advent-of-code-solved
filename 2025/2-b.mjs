import { readFile } from 'node:fs/promises';

console.clear();
console.log('\n\n\n');

const data = (await readFile('./2.sample', 'utf8')).split(',').map((_) =>
  _.trim()
    .split('-')
    .map((_) => parseInt(_, 10))
);

const res = data.reduce((acc, [a, b]) => {
  const range = Array.from({ length: b - a + 1 }, (_, i) => a + i + '').filter(
    (_) => {
      const sizes = Array.from(
        { length: _.length / 2 },
        (_, i) => i + 1
      ).reverse();

      for (let i = 0; i < sizes.length; i++) {
        const frag = _.slice(0, sizes[i]);
        if ((_.length / frag.length) % 1 > 0) {
          // skip
          continue;
        }

        const test = frag.repeat(_.length / frag.length);
        if (test === _) {
          return true;
        }
      }

      return false;
    }
  );

  if (range.length) {
    acc.push(...range);
  }

  return acc;
}, []);
// .reduce((acc, curr) => acc + parseInt(curr), 0);

console.log(res);
