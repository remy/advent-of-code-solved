import test from 'ava';
import { fieldValidators } from '../4-b';

test('byr', (t) => {
  t.is(fieldValidators.byr('1919'), false);
  t.is(fieldValidators.byr('192'), false);
  t.is(fieldValidators.byr('19212'), false);
  t.is(fieldValidators.byr('2003'), false);
  t.is(fieldValidators.byr('2020'), false);
  t.is(fieldValidators.byr('1920'), true);
});

test('iyr', (t) => {
  t.is(fieldValidators.iyr('2009'), false);
  t.is(fieldValidators.iyr('192'), false);
  t.is(fieldValidators.iyr('19212'), false);
  t.is(fieldValidators.iyr('2021'), false);
  t.is(fieldValidators.iyr('2999'), false);
  t.is(fieldValidators.iyr('2010'), true);
  t.is(fieldValidators.iyr('2020'), true);
});

test('eyr', (t) => {
  t.is(fieldValidators.eyr('2019'), false);
  t.is(fieldValidators.eyr('192'), false);
  t.is(fieldValidators.eyr('19212'), false);
  t.is(fieldValidators.eyr('2031'), false);
  t.is(fieldValidators.eyr('2999'), false);
  t.is(fieldValidators.eyr('2020'), true);
  t.is(fieldValidators.eyr('2030'), true);
});

test('hgt', (t) => {
  t.is(fieldValidators.hgt('123'), false);
  t.is(fieldValidators.hgt('cm'), false);
  t.is(fieldValidators.hgt('abc'), false);
  t.is(fieldValidators.hgt('1cm'), false);
  t.is(fieldValidators.hgt('149cm'), false);
  t.is(fieldValidators.hgt('194cm'), false);
  t.is(fieldValidators.hgt('193cm'), true);
  t.is(fieldValidators.hgt('150cm'), true);
  t.is(fieldValidators.hgt('155cm'), true);
  t.is(fieldValidators.hgt('58in'), false);
  t.is(fieldValidators.hgt('77in'), false);
  t.is(fieldValidators.hgt('76in'), true);
  t.is(fieldValidators.hgt('70in'), true);
  t.is(fieldValidators.hgt('59in'), true);
});
