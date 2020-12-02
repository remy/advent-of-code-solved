const readFile = require('fs').readFileSync;

const res = readFile(__dirname + '/../2.input', 'utf-8')
  .split('\n')
  .filter((_) => _.trim())
  // .slice(0, 5)
  .filter((line) => {
    const [rule, password] = line.split(': ');

    let [, min, max, letter] = rule.match(/(\d+)\-(\d+) (\w)/);
    min = parseInt(min, 10);
    max = parseInt(max, 10);

    const count = password.split('').filter((l) => l === letter).length;

    return count >= min && count <= max;
  });

console.log(res.length); // ?
