let distance = 0;
let aim = 159;

const parse = _ => ({
  dir: _.substring(0, 1),
  n: parseInt(_.substring(1), 10),
});

const toString = () =>
  matrix
    .map(_ => {
      return _.map(_ => {
        if (_ === Infinity) return 'o';
        if (_ === 0) return '.';
        if (_ === 1) return '*';
        return _;
      }).join('');
    }, [])
    .join('\n');

let input;
input = [
  'R75,D30,R83,U83,L12,D49,R71,U7,L72',
  '62,R66,U55,R34,D71,R55,D58,R83',
];
//  input = ['R8,U5,L5,D3', 'U7,R6,D4,L4'];

const source = input.map(_ => _.split(',').map(parse)); // ?

function buildMatrix(source) {
  return source.reduce(
    (dims, { dir, n }) => {
      if (dir === 'R') {
        const x = dims.x + n;
        return { ...dims, x, n, w: x };
      }

      if (dir === 'L') {
        let x = dims.x - n;
        if (x < 0) {
          dims.w -= x;
          x = 0;
        }
        return { ...dims, x };
      }

      if (dir === 'U') {
        const y = dims.y + n;
        return { ...dims, y, n, h: y };
      }

      if (dir === 'D') {
        let y = dims.y - n;
        if (y < 0) {
          dims.h -= y; // ?
          y = 0;
        }
        return { ...dims, y };
      }

      throw new Error('Not here');
    },
    { w: 1, h: 1, x: 1, y: 1 }
  );
}

function _buildMatrix(path) {
  return path.reduce(
    (dim, _) => {
      if (_.dir === 'R') {
        return { ...dim, w: dim.x + _.n + dim.w, x: dim.x + _.n };
      }
      if (_.dir === 'U') {
        return { ...dim, h: dim.y + _.n, y: dim.y + _.n }; // ? [$,dim,_]
      }

      if (_.dir === 'L') {
        return {
          ...dim,
          w: dim.w + Math.min(dim.x - _.n, 0) * -1,
          x: Math.max(dim.x - _.n, 0),
        };
      }

      if (_.dir === 'D') {
        return {
          ...dim,
          h: dim.h + Math.min(dim.y - _.n, 0) * -1,
          y: Math.max(dim.y - _.n, 0),
        };
      }
    },
    {
      w: 0,
      h: 0,
      x: 1,
      y: 1,
    }
  );
}

const dims = source.map(buildMatrix).reduce(
  ($, _) => {
    return {
      w: Math.max(_.w, $.w),
      h: Math.max(_.h, $.h),
    };
  },
  { w: 0, h: 0 }
);

const walk = source => {
  let x = 0;
  let y = dims.h - 1;

  matrix[y][0] = Infinity;

  source.forEach(p => {
    let i;
    if (p.dir === 'R') {
      for (i = x + 1; i <= x + p.n; i++) {
        matrix[y][i]++;
      }
      x = i - 1;
    }

    if (p.dir === 'L') {
      for (i = x - 1; i >= x - p.n; i--) {
        matrix[y][i]++;
      }
      x = i + 1;
    }

    if (p.dir === 'D') {
      [p, x, y];
      for (i = y + 1; i <= y + p.n; i++) {
        matrix[i][x]++;
      }
      y = i - 1;
    }

    if (p.dir === 'U') {
      for (i = y - 1; i >= y - p.n; i--) {
        matrix[i][x]++;
      }
      y = i + 1;
    }
  });
};

// init matrix
const matrix = Array.from({ length: dims.h }, () => {
  return Array.from({ length: dims.w }, () => 0);
});

const [first, second] = source;

walk(first);
walk(second);

console.log(source[0].map(_ => `${_.dir}${_.n}`).join(','));
toString(); //?

distance = matrix.reduce((acc, curr, y) => {
  const hits = curr
    .map((_, x) => {
      return {
        hit: _,
        x,
        y: dims.h - y - 1,
      };
    })
    .filter(_ => _.hit > 1);

  if (hits.length && hits[0].hit !== Infinity) {
    const hit = hits[0];
    hit.d = hit.x + hit.y;

    if (hit.d < acc.d || !acc) return hit;
  }

  return acc;
}, false).d; //?

if (distance !== aim) throw new Error('fail');

/*

...+----+
...|....|
...|....|
...|....|
........|
o-------+


+-----+..
|.....|..
|..+--X-+
|..|..|.|
|.-X--+.|
|..|....|
|.......|
o-------+
*/
