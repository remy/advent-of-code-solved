import { readFile } from 'node:fs/promises';

// read and clean
const input = (await readFile('./1.input', 'utf8'))
  .split('\n')
  .filter(Boolean)
  .map((_) => _.trim())
  .map((_) => [_.slice(0, 1), parseInt(_.slice(1), 10)]);

let crosses = 0;

// process

let acc = 50;

for (let [dir, value] of input) {
  // how many full spins
  const spin = Math.floor(value / 100);
  crosses += spin;

  // remove the 100s
  value = value - 100 * spin;

  // work out the number of remaining ticks
  const ticks = acc + value * (dir == 'L' ? -1 : 1);

  if (ticks > 99) {
    crosses++;
  } else if (ticks <= 0 && acc !== 0) {
    crosses++;
  }

  // console.log({
  //   c: acc,
  //   _: d,
  //   n: res,
  //   s: spin,
  //   r,
  //   // cr: cross,
  //   x: crosses,
  // });

  acc = (acc + (dir === 'L' ? 100 - value : value)) % 100;
}

console.log('>', { crosses });
