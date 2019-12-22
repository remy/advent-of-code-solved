let orbitCom = [];

let source = `COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L`
  .split('\n')
  .map(_ => _.split(')'))
  .reduce((acc, [planet, orbiting]) => {
    if (!acc[planet]) acc[planet] = [];
    acc[planet].push(orbiting);

    return acc;
  }, {}); // ?

function load(key, source) {
  return (source[key] || []).reduce((acc, curr) => {
    acc[curr] = load(curr, source);
    return acc;
  }, {});
}

const res = load('COM', source);

console.log(JSON.stringify(res, 0, 2));
