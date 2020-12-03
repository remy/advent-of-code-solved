const readFile = require('fs').readFileSync;

let width = 0;

const rows = readFile(__dirname + '/../3.input', 'utf-8')
  .split('\n')
  .filter((_) => _.trim());

width = rows[0].length;

let collisions = 0;
let x = 0;
for (let i = 0; i < rows.length; i++) {
  if (rows[i][x % width] === '#') {
    collisions++;
  }

  const row = rows[i];
  x += 3;
}

console.log(collisions);
