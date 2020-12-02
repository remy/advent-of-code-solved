const { readFileSync, writeFileSync } = require('fs');

const input = process.argv[2];

if (!input) process.exit(1);

const data = Uint16Array.from(
  readFileSync(__dirname + '/../' + input, 'utf-8')
    .split('\n')
    .filter((_) => _.trim())
    .map((_) => parseInt(_, 10))
);

const file = new TextEncoder().encode(data);
writeFileSync(`${__dirname}/${input}.bin`, data);
