const readFile = require('fs').readFileSync;

//ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm

const fields = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid', 'cid'];

const valid = readFile(__dirname + '/../4.input', 'utf-8')
  .split(/\n{2,}/)
  .filter((record) => {
    record = record.replace(/\n/g, ' ').trim();
    const fields = record.split(' ').map((field) => field.split(':')[0]);

    if (fields.length === 8) {
      return true;
    }

    if (fields.length === 7) {
      // return true if fields does not include cid
      return !fields.includes('cid');
    }

    return false;
  });

console.log(valid.length);
