import { promises as fs } from 'fs';

console.log('-'.repeat(20));

const file = (await fs.readFile('2024/4.input', 'utf8'))
  .trim()
  .split('\n')
  .map((_) => _.trim().split(''));

const state = {
  ptr: {
    x: 0,
    y: 0,
  },
  w: file[0].length,
  h: file.length,
  grid: file,
};

const allDirections = Array.from({ length: 3 }, (_, i) =>
  Array.from({ length: 3 }, (_, j) => {
    return [i - 1, j - 1];
  })
)
  .flat()
  .filter(([x, y]) => x || y);

let found = 0;

do {
  const coords = findX(state);
  if (!coords) {
    break;
  }
  state.ptr.x = coords.x;
  state.ptr.y = coords.y;

  found += search(state, coords, allDirections);
} while (inc());

console.log(found);

function search(state, coords, directions) {
  return directions.reduce((acc, [x, y]) => {
    const test = { ...coords };
    test.x += x;
    test.y += y;
    if (match(state, 'M', test)) {
      test.x += x;
      test.y += y;
      if (match(state, 'A', test)) {
        test.x += x;
        test.y += y;
        if (match(state, 'S', test)) {
          return acc + 1;
        }
      }
    }

    return acc;
  }, 0);
}

function match(state, letter, { x, y }) {
  if (x < 0 || x >= state.w || y < 0 || y >= state.h) {
    return false;
  }

  return state.grid[y][x] === letter;
}

function inc() {
  if (state.ptr.x + 1 < state.w) {
    state.ptr.x++;
  } else {
    state.ptr.x = 0;
    state.ptr.y++;
  }

  return state.ptr.y <= state.h;
}

function findX(input) {
  const { ptr, w, h, grid } = input;

  let { x, y } = ptr;

  while (y < h) {
    if (grid[y][x] === 'X') {
      return { x, y };
    }

    x++;
    if (x >= w) {
      x = 0;
      y++;
    }
  }

  return null;
}
