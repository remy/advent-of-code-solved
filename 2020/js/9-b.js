const readFile = require('fs').readFileSync;

const points = readFile(__dirname + '/../9.input', 'utf-8')
  .trim()
  .split('\n')
  .map((_) => parseInt(_, 10));

// const pre = 25;
// const n = 127;

let target = 0;

// part 1
// for (let i = pre; i < points.length; i++) {
//   const t = points[i];

//   // does any combination of the sum of these values add up to t?
//   const inner = points.slice(i - pre, i);
//   // [inner.length, t]; // ?

//   const calcs = [];
//   for (let j = 0; j < inner.length; j++) {
//     const a = inner[j];

//     for (let k = j; k < inner.length - j; k++) {
//       const b = inner[k];

//       if (a + b == t) {
//         [a, b, t]; // ?
//       }
//       calcs.push(a + b);
//     }
//   }

//   if (!calcs.includes(t)) {
//     target = t;
//     break;
//   }
// }

target = 373803594;
let found = false;

// part 2
for (let i = 0; i < points.length; i++) {
  const outer = points[i];

  const test = [outer];

  for (let j = i + 1; j < points.length; j++) {
    const inner = points[j];
    test.push(inner);

    const res = test.reduce((acc, curr) => (acc += curr), 0);
    //[test, res]; // ?
    if (res > target) break;

    if (res === target) {
      const [min, max] = [Math.min(...test), Math.max(...test)];
      found = min + max;
      console.log({ min, max, res: min + max });
    }
  }
  0;
  if (found) break;
}

found; // ?
