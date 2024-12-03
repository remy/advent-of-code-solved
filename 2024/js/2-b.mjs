import { promises as fs } from 'node:fs';

console.clear();

const test = true;

const data = await fs.readFile(`2024/2.${test ? 'sample' : 'input'}`, 'utf-8');
const lines = data
  .split('\n')
  .filter(Boolean)
  .map((_) => _.split(' ').map(Number));

function bad(report, tolerate) {
  for (let i = 1; i < report.length; i++) {
    const diff = report[i] - report[i - 1];
    console.log({
      diff,
      a: report[i - 1],
      b: report[i - 2],
      z: report[i],
      x: (report[i - 1] - report[i - 2]) * diff <= 0,
    });
    if (Math.abs(diff) > 3 || (report[i - 1] - report[i - 2]) * diff <= 0)
      return (
        !tolerate ||
        [2, 1, 0].every((j) => bad(report.toSpliced(i - j, 1), tolerate - 1))
      );
  }
}

console.log(lines.filter((_) => !bad(_, 1)).length);

// function check(data, dir) {
//   return data.map((_, i, all) => {
//     if (_ == 0) {
//       return false;
//     }

//     if (Math.abs(_) > 3) {
//       return false;
//     }

//     if (_ * dir < 0) {
//       return false;
//     }

//     return true;
//   });

//   // .concat(true);
// }

// function filter(data) {
//   return data.reduce((acc, curr, i, all) => {
//     if (i == all.length - 1) {
//       return acc;
//     }

//     acc.push(all[i + 1] - curr);
//     return acc;
//   }, []);
// }

// function calcBetween(data) {
//   const report = [Array.from(data)];
//   const length = data.length;
//   let res = filter(data);

//   let c1dir = res.reduce((acc, curr) => (acc += curr < 0 ? -1 : +1), 0);

//   let c1 = check(res, c1dir < 0 ? -1 : 1);
//   let c1len = c1.filter(Boolean).length;
//   report.push({ c1, c1len, res: Array.from(res) });

//   if (c1len == length - 1) {
//     // console.log('SAFE (no bad)');
//     // console.log(data);
//     return true;
//   }

//   console.log({ data, res, c1, c1len });

//   // if (c1len == 1) {
//   //   // possibly we need to invert the match
//   //   c1 = check(c1.map((_) => !_));
//   //   c1len = c1.filter(Boolean).length;
//   // }

//   if (c1len <= length - 3) {
//     console.log('UNSAFE (too many bad)');
//     return false;
//   }

//   if (c1len == length - 2) {
//     // remove the item that's false from res, and re-check
//     // console.log(data);
//     report.push('potentially bad', c1);

//     // run through the array removing one item at a time
//     // and checking if it's safe, as soon as one is safe
//     // break and return true
//     for (let i = 0; i < data.length; i++) {
//       const temp = Array.from(data);
//       temp.splice(i, 1);
//       const res = filter(temp);
//       const c1dir = res.reduce((acc, curr) => (acc += curr < 0 ? -1 : +1), 0);
//       const c1 = check(res, c1dir < 0 ? -1 : 1);
//       const c1len = c1.filter(Boolean).length;

//       if (c1len == length - 2) {
//         console.log('MADE SAFE');
//         console.log({ data, temp, res, c1 });
//         return true;
//       }
//     }

//     // console.log('UNSAFE');
//     return false;

//     data = data.filter((_, i) => c1[i]);
//     report.push({ filtered: Array.from(data) });
//     res = filter(data);
//     const c2 = check(res);
//     const c2len = c2.filter(Boolean).length;

//     if (c2len <= length - 2) {
//       console.log('UNSAFE');
//       // log each item in the report array
//       for (const item of report) {
//         console.log(item);
//       }

//       return false;
//     }

//     console.log('MADE SAFE');
//     for (const item of report) {
//       console.log(item);
//     }
//     return true;
//   }

//   // console.log('SAFE');

//   return true;
// }

// if (test) {
//   console.log(calcBetween(lines[3]));
// } else {
//   console.log(lines.map(calcBetween).filter(Boolean).length);
// }

// // console.log(lines.map(calcBetween).filter(Boolean).length);
