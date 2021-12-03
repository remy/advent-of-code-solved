const { readFileSync, writeFileSync } = require('fs');

const input = process.argv[2];

if (!input) process.exit(1);

const data = Uint16Array.from(
  readFileSync('./' + input, 'utf-8')
    .split('\n')
    .filter(Boolean)
    .map((_) => parseInt(_, 10))
);

const file = new TextEncoder().encode(data);
writeFileSync(`${process.cwd()}/${input}.bin`, data);
