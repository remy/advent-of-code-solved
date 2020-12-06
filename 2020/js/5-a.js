const readFile = require('fs').readFileSync;

const codes = readFile(__dirname + '/../5.input', 'utf-8')
  .split('\n')
  .map((_) => _.trim())
  .filter(Boolean);

const decode = (code) => {
  let row = 0;
  let col = 0;

  for (let i = 0; i < code.length; i++) {
    const c = code[i];
    if (i < 7) {
      if (c === 'B') {
        row += 1 + (127 >> (i + 1));
      }
    } else {
      if (c === 'R') {
        col += 1 + (7 >> (i - 7 + 1));
      }
    }
  }

  return row * 8 + col;
};

Math.max(...codes.map(decode)); // ?
