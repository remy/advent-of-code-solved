const [time, distance] = sample()
  .split('\n')
  .map((line) => parseInt(line.trim().match(/(\d+)/g).join('')), 10); // ?

const result = [];

// for (let index = 0; index < [time].length; index++) {
const t = time;
const d = distance;

let res = 0;
for (let i = 1; i < t; i++) {
  if (i * (t - i) > d) {
    res++;
  }
}
// result.push(res);
console.log(res);
// }

// console.log(result.reduce((acc, curr) => acc * curr, 1));

function sample() {
  return `Time:        35     69     68     87
  Distance:   213   1168   1086   1248`;
}
