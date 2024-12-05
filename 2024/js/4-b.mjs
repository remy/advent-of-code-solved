import { promises as fs } from 'fs';

console.log('-'.repeat(20));

const file = (await fs.readFile('2024/4.sample', 'utf8'))
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

const allDirections = [-1, 0, 1]
  .flatMap((dx) => [-1, 0, 1].map((dy) => [dx, dy]))
  .filter(([x, y]) => x || y);

let found = 0;

do {
  const coords = findStart(state);
  if (!coords) {
    break;
  }
  state.ptr.x = coords.x;
  state.ptr.y = coords.y;

  found += search(state, coords, allDirections);
} while (inc());

console.log(found);

function search(state, coords, directions) {
  if (coords.x > state.w - 2 || coords.y > state.h - 2) {
    return 0;
  }

  // now collect a 3x3 grid, first checking for A
  // in the middle
  const slice = state.grid.slice();

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

function findStart(input) {
  const { ptr, w, h, grid } = input;

  let { x, y } = ptr;

  while (y < h) {
    if (grid[y][x] === 'M') {
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
