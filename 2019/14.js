console.clear();

const parse = str => {
  const [l, r] = str.trim().split(' => ');

  var [output, key] = r.split(' ');
  output = parseInt(output, 10);

  let makesOre = false;

  var from = l.split(/\s*,\s*/).map(_ => {
    var [makes, key] = _.replace(',', '').split(' ');
    makes = parseInt(makes, 10);

    if (key === 'ORE') makesOre = true;

    return [key, makes];
  });

  return { [key]: { output, from, required: 0, makesOre } };
};

function test(s, expect) {
  const res = main(s);
  if (res !== expect) {
    console.log('\n----- FAIL -----');

    console.log(s);
    console.log('\nexepected ' + expect + `, got: ${res}`);

    throw new Error('fail');
  }
}

function main(s) {
  console.log('-------------');
  const $_ = s
    .split('\n')
    .filter(Boolean)
    .map(parse)
    .reduce(
      (acc, curr) => {
        const key = Object.keys(curr)[0];
        acc[key] = curr[key];
        acc.inventory[key] = 0;
        return acc;
      },
      {
        ORE: { required: 0, from: [] },
        inventory: { ORE: 0 },
      }
    );

  return calcReaction('FUEL', 1, $_).ORE.required; // ?
  // return calc($_); // ?
}

function calcReaction(from, need, reactions) {
  const reaction = reactions[from];
  const output = reaction.output;

  const res = reaction.from.map(([key, input]) => {
    const needToProduce =
      Math.ceil(need / output) * input - reactions.inventory[key];

    const willProduce =
      Math.ceil(needToProduce / (reactions[key].output || 1)) *
      (reactions[key].output || 1);

    const overflow = willProduce - needToProduce;

    // var a = `Need to produce ${needToProduce} ${key} to produce ${need} ${from}, ${key} is made ${reactions[
    //   key
    // ].output ||
    //   1} at a time, combination ${key} generates a total of ${willProduce} giving us an overflow of ${overflow} (current overflow inventory: ${
    //   reactions.inventory[key]
    // })`; // ?

    // a = {
    //   from,
    //   [`${from}output`]: reactions[key].output || 1,
    //   currentInventory: reactions.inventory[key],
    //   key,
    //   [`${key}output`]: output,
    //   need,
    //   needToProduce,
    //   input,
    //   overflow,
    //   willProduce,
    // };

    reactions.inventory[key] = overflow;
    reactions[key].required += needToProduce;

    calcReaction(key, willProduce, reactions);
  });

  return reactions;
}

function calc($_) {
  return Object.entries($_)
    .filter(([key, val]) => val.makesOre)
    .map(([key, val]) => {
      const needToMake = val.from[0][1];
      const required = Math.ceil(val.required / val.output) * needToMake;

      return { key, required };
    })
    .reduce((acc, curr) => acc + curr.required, 0); // ?
}

// test(
//   `
// 10 ORE => 10 A
// 1 ORE => 1 B
// 7 A, 1 B => 1 C
// 7 A, 1 C => 1 D
// 7 A, 1 D => 1 E
// 7 A, 1 E => 1 FUEL
// `,
//   31
// );

// test(
//   `
// 10 ORE => 10 A
// 1 ORE => 1 B
// 7 A, 1 B => 2 C
// 7 A, 1 C => 1 D
// 7 A, 1 D, 1 C => 1 E
// 7 A, 1 E => 1 FUEL
// `,
//   31
// );

// test(
//   `
// 9 ORE => 2 A
// 8 ORE => 3 B
// 7 ORE => 5 C
// 3 A, 4 B => 1 AB
// 5 B, 7 C => 1 BC
// 4 C, 1 A => 1 CA
// 2 AB, 3 BC, 4 CA => 1 FUEL
// `,
//   165
// );

// test(
//   `
// 10 ORE => 10 A
// 1 A => 1 FUEL
// `,
//   10
// );

// test(
//   `
// 10 ORE => 10 A
// 1 ORE => 1 B
// 1 A, 1 B => 1 FUEL
// `,
//   11
// );

// test(
//   `
// 10 ORE => 10 A
// 1 ORE => 1 B
// 1 A, 2 B => 1 FUEL
// `,
//   12
// );

// test(
//   `
// 10 ORE => 10 A
// 1 ORE => 2 B
// 1 A, 2 B => 1 FUEL
// `,
//   11
// );

// test(
//   `
// 10 ORE => 10 A
// 1 ORE => 2 B
// 1 A, 1 B => 9 Q
// 1 A, 2 B, 1 Q => 1 FUEL
// `,
//   12
// );

// test(
//   `
// 10 ORE => 10 A
// 1 ORE => 2 B
// 1 A, 1 B => 9 Q
// 1 A, 2 B, 2 Q => 1 FUEL
// `,
//   12
// );

// test(
//   `
// 10 ORE => 10 A
// 1 ORE => 2 B
// 1 A, 4 B => 9 Q
// 3 Q => 1 FUEL
// `,
//   12
// );

test(
  `
157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
`,
  13312
);

test(
  `139 ORE => 4 A
  144 ORE => 7 B
  145 ORE => 6 C
  176 ORE => 6 D
  1 A => 8 E
  17 A, 3 B => 8 AB
  22 D, 37 C => 5 DC
  1 D, 6 C => 4 DC2
  5 D, 7 C, 9 AB, 37 E => 6 ZZZ
  2 AB, 7 DC, 2 E, 11 C => 1 XXX
  5 C, 7 DC2, 2 DC, 2 AB, 19 E => 3 YYY
  53 XXX, 6 C, 46 D, 81 YYY, 68 E, 25 ZZZ => 1 FUEL`,
  180697
);

test(
  `171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX`,
  2210736
);
