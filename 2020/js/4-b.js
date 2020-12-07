const readFile = require('fs').readFileSync;

/**
 *
    byr (Birth Year) - four digits; at least 1920 and at most 2002.
    iyr (Issue Year) - four digits; at least 2010 and at most 2020.
    eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    hgt (Height) - a number followed by either cm or in:
        If cm, the number must be at least 150 and at most 193.
        If in, the number must be at least 59 and at most 76.
    hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    pid (Passport ID) - a nine-digit number, including leading zeroes.
    cid (Country ID) - ignored, missing or not.

 */

const nop = () => {};

const numValidator = (min, max) => {
  return (value) => {
    value = value.trim();
    if (value.length !== 4) return false;

    const year = parseInt(value, 10);
    if (year < min) return false;
    if (year > max) return false;

    return true;
  };
};

const fieldValidators = {
  byr: numValidator(1920, 2020),
  iyr: numValidator(2010, 2020),
  eyr: numValidator(2020, 2030),
  hgt(value) {
    const number = parseInt(value.slice(0, -2), 10);
    if (value.endsWith('cm')) {
      if (number >= 150 && number <= 193) return true;
    }

    if (value.endsWith('in')) {
      if (number >= 59 && number <= 76) return true;
    }

    return false;
  },
  hcl(value) {
    return /^#[0-9a-f]{6}$/.test(value);
  },
  ecl(value) {
    return ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].includes(value);
  },
  pid(value) {
    return /^[0-9]{9}$/.test(value);
  },
  cid() {
    return true;
  },
};

const keys = Object.keys(fieldValidators);

const validateRecord = (record) => {
  record = record.replace(/\n/g, ' ').trim();
  const fields = record
    .split(' ')
    .map((field) => field.split(':'))
    .reduce((acc, [key, value]) => {
      acc[key] = value.trim();
      return acc;
    }, {});

  let valid = keys.filter((key) => {
    const value = fields[key];
    if (!value && key !== 'cid') return false;
    return fieldValidators[key](fields[key]);
  }).length;

  if (valid === 8) {
    fields; // ?
    return true;
  }

  return false;
};

const valid = readFile(__dirname + '/../4.input', 'utf-8')
  .split(/\n{2,}/)
  .filter(validateRecord);

console.log(valid.length);
