const readFile = require('fs').readFileSync;

function treeRun({ right, down }) {
  let collisions = 0;
  let x = 0;
  for (let i = 0; i < rows.length; i += down) {
    if (rows[i][x % width] === '#') {
      collisions++;
    }

    const row = rows[i];
    x += right;
  }

  return collisions;
}

let width = 0;

const rows = readFile(__dirname + '/../3.input', 'utf-8')
  .split('\n')
  .filter((_) => _.trim());

width = rows[0].length;

let collisions = treeRun({ right: 1, down: 1 });
collisions *= treeRun({ right: 3, down: 1 });
collisions *= treeRun({ right: 5, down: 1 });
collisions *= treeRun({ right: 7, down: 1 });
collisions *= treeRun({ right: 1, down: 2 });

// console.log(collisions);
