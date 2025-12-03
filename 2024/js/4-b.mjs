import { promises as fs } from 'fs';

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

let found = 0;

do {
  const coords = findStart(state);
  if (!coords || coords.y === state.h - 3) {
    break;
  }
  state.ptr.x = coords.x;
  state.ptr.y = coords.y;

  found += search(state, coords);
} while (inc());

console.log(found);

function search(state, coords) {
  if (coords.x > state.w - 3 || coords.y > state.h - 3) {
    return 0;
  }

  // now collect a 3x3 grid, first checking for A
  // in the middle
  const slice = state.grid
    .slice(coords.y, coords.y + 3)
    .map((_) => _.slice(coords.x, coords.x + 3));

  if (slice[1][1] !== 'A') {
    return 0;
  }

  const s = `${slice[0][0]}${slice[0][2]}${slice[2][0]}${slice[2][2]}`;

  if (s === 'MSMS' || s === 'SMSM') {
    // console.log(s);
    return 1;
  }

  return 0;

  if (slice[0][0] === 'M' && slice[0][2] === 'S')
    if (slice[2][2] === 'S' && slice[2][0] === 'M') return 1;

  if (slice[0][2] === 'M' && slice[0][0] === 'S')
    if (slice[2][2] === 'M' && slice[0][0] === 'M') return 1;

  // console.log(found, slice);
  // return found == 2 ? 1 : 0;
  return 0;
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
    const p = grid[y][x];
    if (p === 'M' || p === 'S') {
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
