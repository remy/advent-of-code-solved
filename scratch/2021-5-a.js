// find overlap
const array = fixture();

const done = new Set();

const START = 0;
const END = 1;

for (let i = 0; i < array.length; i++) {
  const vector = array[i];

  for (let j = 0; j < array.length; j++) {
    const vector2 = array[j];
    const key = [i, j].sort().join('-');

    // skip pairs already done
    if (done.has(key)) {
      continue;
    }

    done.add(key);

    const LINE = 'y';
    const AXIS = 'x';

    // when they're on the same row/y axis, then...
    if (j !== i) {
      if (vector[START][LINE] === vector2[START][LINE]) {
        if (
          vector[START][AXIS] <= vector2[START][AXIS] &&
          vector2[START][AXIS] <= vector[END][AXIS]
        ) {
          const len1 = vector[END][AXIS] - vector[START][AXIS] + 1;
          const len2 = vector2[END][AXIS] - vector2[START][AXIS] + 1;
          const overlap = len1 - vector2[START][AXIS] - len2;
          console.log({ vector, vector2, len1, len2, overlap });
        }
      }
    }
  }
}

function fixture() {
  return [
    [
      {
        x: 0,
        y: 9,
      },
      {
        x: 5,
        y: 9,
      },
    ],
    [
      {
        x: 9,
        y: 4,
      },
      {
        x: 3,
        y: 4,
      },
    ],
    [
      {
        x: 2,
        y: 2,
      },
      {
        x: 2,
        y: 1,
      },
    ],
    [
      {
        x: 7,
        y: 0,
      },
      {
        x: 7,
        y: 4,
      },
    ],
    [
      {
        x: 0,
        y: 9,
      },
      {
        x: 2,
        y: 9,
      },
    ],
    [
      {
        x: 3,
        y: 4,
      },
      {
        x: 1,
        y: 4,
      },
    ],
  ];
}
