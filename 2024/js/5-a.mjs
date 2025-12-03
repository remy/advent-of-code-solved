import { promises as fs } from 'node:fs';
console.clear();

const file = await fs.readFile('./5.sample', 'utf-8');

const orderRules = file
  .split('\n\n')[0]
  .trim()
  .split('\n')
  .map((_) => _.split('|').map((_) => parseInt(_, 10)))
  .reduce((acc, [a, b]) => {
    if (!acc[a]) {
      acc[a] = {
        after: [],
        before: [],
      };
    }

    if (!acc[b]) {
      acc[b] = {
        after: [],
        before: [],
      };
    }

    acc[a].after.push(b);
    acc[b].before.push(a);

    return acc;
  }, {});

const updates = file
  .split('\n\n')[1]
  .split('\n')
  .map((_) => _.split(',').map((_) => parseInt(_, 10)));

const correctUpdates = [];

for (const update of updates) {
  let ok = 0;
  for (let i = 0; i < update.length; i++) {
    const before = i === 0 ? [] : update.slice(0, i);
    const current = update[i];
    const after = update.slice(i + 1);

    const okB = after.every((n) => orderRules[current].after.includes(n));

    const okA = before.every((n) => orderRules[current].before.includes(n));

    if (okA && okB) {
      ok++;
    }
  }
  if (ok === update.length) {
    correctUpdates.push([...update]);
  }
}

console.log(
  correctUpdates
    .map((_) => _[(_.length / 2) | 0])
    .reduce((acc, curr) => (acc += curr), 0)
);
