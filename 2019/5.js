console.clear();
// const source = [1002, 5, 3, 5, 99, 33];
// const source = [1002,4,3,4,99];
let source = JSON.parse(
  '[' + require('fs').readFileSync('./5.input', 'utf8') + ']'
);

// source = [1002, 4, 3, 4, 33];
// source = [1002, 4, 3, 4, 33];

// source = [101, -176, 224, 224, 4, 224, ...Array.from({ length: 255 }, () => 2)]; // ? $.length

let i = 0;

const input = 1;
let output = null;

const getMode = (op, pos) => {
  op = op.toString().padStart(5, '0');
  return parseInt(op[op.length - 2 - pos], 10);
};

do {
  source[i];
  source[i];
  const op = source[i] % 100;

  if (![1, 2, 3, 4, 99].includes(op)) {
    throw new Error(`unknown op code: ${op} @ ${i} / ${source}`);
  }

  if (op < 3) {
    let pos = source[i + 1];
    let a, b;
    const amode = getMode(source[i], 1);
    a = amode ? pos : source[pos];
    pos = source[i + 2];
    const bmode = getMode(source[i], 2);
    b = bmode ? pos : source[pos];

    pos = source[i + 3];

    if (op === 1) {
      source[pos] = a + b;
    }

    if (op === 2) {
      source[pos] = a * b;
    }
  } else if (op < 99) {
    const pos = source[i + 1];
    const mode = getMode(source[i], 1);

    if (op === 3) {
      source[pos] = input;
    } else {
      output = mode ? pos : source[pos]; // ?
    }
  }

  if (op === 99) throw new Error(`halt: ` + source);
  else if (op < 3) i += 4;
  else i += 2;
} while (i < source.length);

console.log(source[0]);
