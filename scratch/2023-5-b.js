const input = prod();

function findMap(name) {
  return input.maps.find((map) => map.from === name);
}

const mapNames = input.maps.map((map) => map.from); // ?

console.log('\n\n\n');
console.log('-'.repeat(40));
console.log('\n\n\n');

const log = console.log.bind(console);

let logging = true;
console.log = (...args) => {
  if (logging) {
    log.apply(console, args);
  }
};

const res = mapNames.reduce(
  (seeds, mapName, i) => {
    // logging = mapNames[i] === 'light';
    const before = [...seeds].sort((a, b) => a.from - b.from);
    let acc = seeds.map((seed) => find(seed, findMap(mapName).map)).flat();

    console.log(
      `${mapNames[i]} -> ${mapNames[i + 1] || 'location'}\nfrom:`,
      before,
      '\nto:',
      [...acc].sort((a, b) => a.from - b.from),
      '\n\n'
    );
    return acc;
  },
  [{ from: 304740406, to: 304740407 }]
); // input.seeds.slice(1));

logging = true;
console.log(res.sort((a, b) => a.from - b.from));

function find(source, maps) {
  const result = maps
    .map((map) => {
      if (source.from >= map.from && source.from <= map.to) {
        const offset = source.from - map.from;
        const dest = map.dest + offset;

        if (source.to <= map.to) {
          console.log('inside');
          return [{ from: dest, to: dest + (source.to - source.from) }];
        } else {
          console.log('split', {
            source,
            map,
            res: { from: dest, to: map.dest + (map.range - 1) },
          });
          return [{ from: dest, to: map.dest + (map.range - 1) }]
            .concat(
              find(
                {
                  from: map.from + map.range,
                  to: source.to,
                },
                maps
              )
            )
            .filter(Boolean);
          // find the split - recursively
        }
      }
    })
    .filter(Boolean);

  if (result.length === 0) {
    // console.log('outside', source);
    return [{ from: source.from, to: source.to }];
  }

  return result.flat();
}

function prod() {
  return {
    seeds: [
      {
        from: 90744016,
        range: 147784453,
        to: 238528468,
      },
      {
        from: 304740406,
        range: 53203352,
        to: 357943757,
      },
      {
        from: 577905361,
        range: 122056749,
        to: 699962109,
      },
      {
        from: 1080760686,
        range: 52608146,
        to: 1133368831,
      },
      {
        from: 1445830299,
        range: 58442414,
        to: 1504272712,
      },
      {
        from: 1670978447,
        range: 367043978,
        to: 2038022424,
      },
      {
        from: 2284615844,
        range: 178205532,
        to: 2462821375,
      },
      {
        from: 3164519436,
        range: 564398605,
        to: 3728918040,
      },
      {
        from: 4012995194,
        range: 104364808,
        to: 4117360001,
      },
      {
        from: 4123691336,
        range: 167638723,
        to: 4291330058,
      },
    ],
    maps: [
      {
        from: 'seed',
        to: 'soil',
        map: [
          {
            dest: 0,
            from: 699677807,
            range: 922644641,
            to: 1622322447,
          },
          {
            dest: 4174180469,
            from: 3833727510,
            range: 120786827,
            to: 3954514336,
          },
          {
            dest: 1525682201,
            from: 2566557266,
            range: 229511566,
            to: 2796068831,
          },
          {
            dest: 3280624601,
            from: 3954514337,
            range: 340452959,
            to: 4294967295,
          },
          {
            dest: 2228029508,
            from: 2796068832,
            range: 310221139,
            to: 3106289970,
          },
          {
            dest: 3621077560,
            from: 3280624601,
            range: 553102909,
            to: 3833727509,
          },
          {
            dest: 2120836342,
            from: 592484641,
            range: 107193166,
            to: 699677806,
          },
          {
            dest: 1982514669,
            from: 227320902,
            range: 138321673,
            to: 365642574,
          },
          {
            dest: 1755193767,
            from: 0,
            range: 227320902,
            to: 227320901,
          },
          {
            dest: 922644641,
            from: 1622322448,
            range: 603037560,
            to: 2225360007,
          },
          {
            dest: 2538250647,
            from: 365642575,
            range: 226842066,
            to: 592484640,
          },
          {
            dest: 2765092713,
            from: 2225360008,
            range: 341197258,
            to: 2566557265,
          },
        ],
      },
      {
        from: 'soil',
        to: 'fertilizer',
        map: [
          {
            dest: 1916776044,
            from: 145070025,
            range: 3464138,
            to: 148534162,
          },
          {
            dest: 1920240182,
            from: 0,
            range: 145070025,
            to: 145070024,
          },
          {
            dest: 706160141,
            from: 2208005933,
            range: 115191764,
            to: 2323197696,
          },
          {
            dest: 2898492924,
            from: 830275742,
            range: 87027483,
            to: 917303224,
          },
          {
            dest: 3489083348,
            from: 3344594558,
            range: 103871907,
            to: 3448466464,
          },
          {
            dest: 2985520407,
            from: 148534163,
            range: 415139950,
            to: 563674112,
          },
          {
            dest: 821351905,
            from: 917303225,
            range: 327392865,
            to: 1244696089,
          },
          {
            dest: 1148744770,
            from: 1517236949,
            range: 182706102,
            to: 1699943050,
          },
          {
            dest: 295069722,
            from: 3448466465,
            range: 411090419,
            to: 3859556883,
          },
          {
            dest: 1816984891,
            from: 3244803405,
            range: 99791153,
            to: 3344594557,
          },
          {
            dest: 4282585972,
            from: 4292886644,
            range: 2080652,
            to: 4294967295,
          },
          {
            dest: 3592955255,
            from: 563674113,
            range: 266601629,
            to: 830275741,
          },
          {
            dest: 4266462972,
            from: 4158154511,
            range: 16123000,
            to: 4174277510,
          },
          {
            dest: 1331450872,
            from: 1244696090,
            range: 272540859,
            to: 1517236948,
          },
          {
            dest: 2715943131,
            from: 3062253612,
            range: 182549793,
            to: 3244803404,
          },
          {
            dest: 4284666624,
            from: 4174277511,
            range: 10300672,
            to: 4184578182,
          },
          {
            dest: 4158154511,
            from: 4184578183,
            range: 108308461,
            to: 4292886643,
          },
          {
            dest: 1603991731,
            from: 1995012773,
            range: 212993160,
            to: 2208005932,
          },
          {
            dest: 2065310207,
            from: 2411620688,
            range: 650632924,
            to: 3062253611,
          },
          {
            dest: 0,
            from: 1699943051,
            range: 295069722,
            to: 1995012772,
          },
          {
            dest: 3400660357,
            from: 2323197697,
            range: 88422991,
            to: 2411620687,
          },
        ],
      },
      {
        from: 'fertilizer',
        to: 'water',
        map: [
          {
            dest: 3585244197,
            from: 3493316345,
            range: 482900943,
            to: 3976217287,
          },
          {
            dest: 2871272496,
            from: 878061687,
            range: 456215665,
            to: 1334277351,
          },
          {
            dest: 3477664135,
            from: 4187387234,
            range: 107580062,
            to: 4294967295,
          },
          {
            dest: 845559238,
            from: 15587711,
            range: 56716031,
            to: 72303741,
          },
          {
            dest: 121711204,
            from: 2918313406,
            range: 409174755,
            to: 3327488160,
          },
          {
            dest: 1639718746,
            from: 0,
            range: 15587711,
            to: 15587710,
          },
          {
            dest: 530885959,
            from: 2603640127,
            range: 314673279,
            to: 2918313405,
          },
          {
            dest: 902275269,
            from: 2435903232,
            range: 167736895,
            to: 2603640126,
          },
          {
            dest: 2635221133,
            from: 72303742,
            range: 236051363,
            to: 308355104,
          },
          {
            dest: 1070012164,
            from: 308355105,
            range: 569706582,
            to: 878061686,
          },
          {
            dest: 1699846244,
            from: 1334277352,
            range: 935374889,
            to: 2269652240,
          },
          {
            dest: 4279315086,
            from: 3477664135,
            range: 15652210,
            to: 3493316344,
          },
          {
            dest: 1655306457,
            from: 2269652241,
            range: 44539787,
            to: 2314192027,
          },
          {
            dest: 109056711,
            from: 2423248739,
            range: 12654493,
            to: 2435903231,
          },
          {
            dest: 0,
            from: 2314192028,
            range: 109056711,
            to: 2423248738,
          },
          {
            dest: 4068145140,
            from: 3976217288,
            range: 211169946,
            to: 4187387233,
          },
        ],
      },
      {
        from: 'water',
        to: 'light',
        map: [
          {
            dest: 3841742547,
            from: 3016842841,
            range: 17384315,
            to: 3034227155,
          },
          {
            dest: 2875021919,
            from: 2637593760,
            range: 185450069,
            to: 2823043828,
          },
          {
            dest: 3413635232,
            from: 3588265685,
            range: 87508205,
            to: 3675773889,
          },
          {
            dest: 1311241677,
            from: 236307150,
            range: 54007684,
            to: 290314833,
          },
          {
            dest: 3349161906,
            from: 4276682782,
            range: 18284514,
            to: 4294967295,
          },
          {
            dest: 896790030,
            from: 1355845673,
            range: 34430118,
            to: 1390275790,
          },
          {
            dest: 3060471988,
            from: 3835573209,
            range: 145836645,
            to: 3981409853,
          },
          {
            dest: 2741184131,
            from: 3675773890,
            range: 133837788,
            to: 3809611677,
          },
          {
            dest: 1387754847,
            from: 947687177,
            range: 15489861,
            to: 963177037,
          },
          {
            dest: 3785944618,
            from: 2057196631,
            range: 55797929,
            to: 2112994559,
          },
          {
            dest: 2006585491,
            from: 2931426646,
            range: 85416195,
            to: 3016842840,
          },
          {
            dest: 3873217816,
            from: 3809611678,
            range: 25961531,
            to: 3835573208,
          },
          {
            dest: 1667765627,
            from: 643929130,
            range: 34884144,
            to: 678813273,
          },
          {
            dest: 2092001686,
            from: 2434956599,
            range: 202637161,
            to: 2637593759,
          },
          {
            dest: 1001898651,
            from: 158618769,
            range: 77688381,
            to: 236307149,
          },
          {
            dest: 3899179347,
            from: 2253048950,
            range: 181907649,
            to: 2434956598,
          },
          {
            dest: 1786416461,
            from: 377140410,
            range: 101956748,
            to: 479097157,
          },
          {
            dest: 0,
            from: 833901414,
            range: 113785763,
            to: 947687176,
          },
          {
            dest: 1403244708,
            from: 479097158,
            range: 56815029,
            to: 535912186,
          },
          {
            dest: 3859126862,
            from: 3034227156,
            range: 14090954,
            to: 3048318109,
          },
          {
            dest: 747996464,
            from: 678813274,
            range: 31450438,
            to: 710263711,
          },
          {
            dest: 869173795,
            from: 963177038,
            range: 27616235,
            to: 990793272,
          },
          {
            dest: 3268502638,
            from: 2006585491,
            range: 50611140,
            to: 2057196630,
          },
          {
            dest: 113785763,
            from: 0,
            range: 148879571,
            to: 148879570,
          },
          {
            dest: 262665334,
            from: 1511505797,
            range: 386606610,
            to: 1898112406,
          },
          {
            dest: 1187603975,
            from: 710263712,
            range: 123637702,
            to: 833901413,
          },
          {
            dest: 3319113778,
            from: 3987361499,
            range: 30048128,
            to: 4017409626,
          },
          {
            dest: 3367446420,
            from: 2885237834,
            range: 46188812,
            to: 2931426645,
          },
          {
            dest: 931220148,
            from: 990793273,
            range: 15913032,
            to: 1006706304,
          },
          {
            dest: 1460059737,
            from: 1006706305,
            range: 120880314,
            to: 1127586618,
          },
          {
            dest: 1079587032,
            from: 535912187,
            range: 108016943,
            to: 643929129,
          },
          {
            dest: 3645890228,
            from: 2112994560,
            range: 140054390,
            to: 2253048949,
          },
          {
            dest: 3206308633,
            from: 2823043829,
            range: 62194005,
            to: 2885237833,
          },
          {
            dest: 1888373209,
            from: 148879571,
            range: 9739198,
            to: 158618768,
          },
          {
            dest: 3501143437,
            from: 3443518894,
            range: 144746791,
            to: 3588265684,
          },
          {
            dest: 779446902,
            from: 1127586619,
            range: 89726893,
            to: 1217313511,
          },
          {
            dest: 947133180,
            from: 1217313512,
            range: 54765471,
            to: 1272078982,
          },
          {
            dest: 2481910976,
            from: 4017409627,
            range: 259273155,
            to: 4276682781,
          },
          {
            dest: 1365249361,
            from: 1390275791,
            range: 22505486,
            to: 1412781276,
          },
          {
            dest: 4087038641,
            from: 3048318110,
            range: 207928655,
            to: 3256246764,
          },
          {
            dest: 1702649771,
            from: 1272078983,
            range: 83766690,
            to: 1355845672,
          },
          {
            dest: 649271944,
            from: 1412781277,
            range: 98724520,
            to: 1511505796,
          },
          {
            dest: 2294638847,
            from: 3256246765,
            range: 187272129,
            to: 3443518893,
          },
          {
            dest: 4081086996,
            from: 3981409854,
            range: 5951645,
            to: 3987361498,
          },
          {
            dest: 1580940051,
            from: 290314834,
            range: 86825576,
            to: 377140409,
          },
        ],
      },
      {
        from: 'light',
        to: 'temperature',
        map: [
          {
            dest: 2659452899,
            from: 3773423191,
            range: 23529065,
            to: 3796952255,
          },
          {
            dest: 1010417677,
            from: 1830019321,
            range: 229964714,
            to: 2059984034,
          },
          {
            dest: 1506263997,
            from: 1764304095,
            range: 65715226,
            to: 1830019320,
          },
          {
            dest: 3017023682,
            from: 3993999178,
            range: 103632805,
            to: 4097631982,
          },
          {
            dest: 3758361154,
            from: 3931294907,
            range: 62704271,
            to: 3993999177,
          },
          {
            dest: 2513441862,
            from: 2529586713,
            range: 106552791,
            to: 2636139503,
          },
          {
            dest: 3821065425,
            from: 3163657189,
            range: 7959671,
            to: 3171616859,
          },
          {
            dest: 3410504451,
            from: 3191697730,
            range: 271334719,
            to: 3463032448,
          },
          {
            dest: 2500616406,
            from: 3150831733,
            range: 12825456,
            to: 3163657188,
          },
          {
            dest: 2065874786,
            from: 2636139504,
            range: 257698620,
            to: 2893838123,
          },
          {
            dest: 4142272690,
            from: 2382216135,
            range: 108163002,
            to: 2490379136,
          },
          {
            dest: 1377732678,
            from: 1378901025,
            range: 61208694,
            to: 1440109718,
          },
          {
            dest: 91217027,
            from: 248578952,
            range: 8927711,
            to: 257506662,
          },
          {
            dest: 2463617376,
            from: 3879075083,
            range: 36999030,
            to: 3916074112,
          },
          {
            dest: 3982807123,
            from: 2315058258,
            range: 67157877,
            to: 2382216134,
          },
          {
            dest: 2323573406,
            from: 2065874786,
            range: 97274446,
            to: 2163149231,
          },
          {
            dest: 958870382,
            from: 916323074,
            range: 51547295,
            to: 967870368,
          },
          {
            dest: 3868386197,
            from: 3579887474,
            range: 114420926,
            to: 3694308399,
          },
          {
            dest: 931392999,
            from: 1351423642,
            range: 27477383,
            to: 1378901024,
          },
          {
            dest: 2942753127,
            from: 3694308400,
            range: 74270555,
            to: 3768578954,
          },
          {
            dest: 1812734437,
            from: 168620508,
            range: 79958444,
            to: 248578951,
          },
          {
            dest: 3301364949,
            from: 2163149232,
            range: 3197696,
            to: 2166346927,
          },
          {
            dest: 2420847852,
            from: 2166346928,
            range: 42769524,
            to: 2209116451,
          },
          {
            dest: 3829025096,
            from: 3111470632,
            range: 39361101,
            to: 3150831732,
          },
          {
            dest: 2619994653,
            from: 2490379137,
            range: 39207576,
            to: 2529586712,
          },
          {
            dest: 1571979223,
            from: 1523548881,
            range: 240755214,
            to: 1764304094,
          },
          {
            dest: 2927532333,
            from: 3916074113,
            range: 15220794,
            to: 3931294906,
          },
          {
            dest: 3125500723,
            from: 4097631983,
            range: 175864226,
            to: 4273496208,
          },
          {
            dest: 1438941372,
            from: 10080856,
            range: 67322625,
            to: 77403480,
          },
          {
            dest: 2049903179,
            from: 0,
            range: 10080856,
            to: 10080855,
          },
          {
            dest: 3304562645,
            from: 2209116452,
            range: 105941806,
            to: 2315058257,
          },
          {
            dest: 1976132043,
            from: 1277652506,
            range: 73771136,
            to: 1351423641,
          },
          {
            dest: 2659202229,
            from: 3171616860,
            range: 250670,
            to: 3171867529,
          },
          {
            dest: 4256036535,
            from: 3463032449,
            range: 38930761,
            to: 3501963209,
          },
          {
            dest: 1240382391,
            from: 257506663,
            range: 137350287,
            to: 394856949,
          },
          {
            dest: 0,
            from: 77403481,
            range: 91217027,
            to: 168620507,
          },
          {
            dest: 3120656487,
            from: 3768578955,
            range: 4844236,
            to: 3773423190,
          },
          {
            dest: 100144738,
            from: 967870369,
            range: 309782137,
            to: 1277652505,
          },
          {
            dest: 409926875,
            from: 394856950,
            range: 521466124,
            to: 916323073,
          },
          {
            dest: 2682981964,
            from: 4273496209,
            range: 21471087,
            to: 4294967295,
          },
          {
            dest: 2704453051,
            from: 3501963210,
            range: 77924264,
            to: 3579887473,
          },
          {
            dest: 2802207515,
            from: 2893838124,
            range: 125324818,
            to: 3019162941,
          },
          {
            dest: 3681839170,
            from: 3796952256,
            range: 76521984,
            to: 3873474239,
          },
          {
            dest: 4250435692,
            from: 3873474240,
            range: 5600843,
            to: 3879075082,
          },
          {
            dest: 1892692881,
            from: 1440109719,
            range: 83439162,
            to: 1523548880,
          },
          {
            dest: 4049965000,
            from: 3019162942,
            range: 92307690,
            to: 3111470631,
          },
          {
            dest: 2782377315,
            from: 3171867530,
            range: 19830200,
            to: 3191697729,
          },
        ],
      },
      {
        from: 'temperature',
        to: 'humidity',
        map: [
          {
            dest: 1281293605,
            from: 2434144353,
            range: 57731817,
            to: 2491876169,
          },
          {
            dest: 3534843655,
            from: 3623804479,
            range: 36539813,
            to: 3660344291,
          },
          {
            dest: 1516028925,
            from: 367078655,
            range: 499627624,
            to: 866706278,
          },
          {
            dest: 3340374639,
            from: 3427302148,
            range: 25514722,
            to: 3452816869,
          },
          {
            dest: 1176213912,
            from: 2491876170,
            range: 105079693,
            to: 2596955862,
          },
          {
            dest: 3872645852,
            from: 3827818849,
            range: 188531931,
            to: 4016350779,
          },
          {
            dest: 508302359,
            from: 1375008638,
            range: 300832898,
            to: 1675841535,
          },
          {
            dest: 0,
            from: 866706279,
            range: 508302359,
            to: 1375008637,
          },
          {
            dest: 4146417618,
            from: 3475254801,
            range: 148549678,
            to: 3623804478,
          },
          {
            dest: 4083438506,
            from: 3660344292,
            range: 62979112,
            to: 3723323403,
          },
          {
            dest: 3365889361,
            from: 3745584127,
            range: 82234722,
            to: 3827818848,
          },
          {
            dest: 4061177783,
            from: 3723323404,
            range: 22260723,
            to: 3745584126,
          },
          {
            dest: 2015656549,
            from: 1675841536,
            range: 348405327,
            to: 2024246862,
          },
          {
            dest: 1056134836,
            from: 246999579,
            range: 120079076,
            to: 367078654,
          },
          {
            dest: 3448124083,
            from: 3452816870,
            range: 22437931,
            to: 3475254800,
          },
          {
            dest: 3321587434,
            from: 3408514943,
            range: 18787205,
            to: 3427302147,
          },
          {
            dest: 3470562014,
            from: 4016350780,
            range: 64281641,
            to: 4080632420,
          },
          {
            dest: 3571383468,
            from: 3321587434,
            range: 86927509,
            to: 3408514942,
          },
          {
            dest: 1339025422,
            from: 2024246863,
            range: 177003503,
            to: 2201250365,
          },
          {
            dest: 809135257,
            from: 0,
            range: 246999579,
            to: 246999578,
          },
          {
            dest: 2364061876,
            from: 2596955863,
            range: 115651453,
            to: 2712607315,
          },
          {
            dest: 3658310977,
            from: 4080632421,
            range: 214334875,
            to: 4294967295,
          },
          {
            dest: 2479713329,
            from: 2201250366,
            range: 232893987,
            to: 2434144352,
          },
        ],
      },
      {
        from: 'humidity',
        to: 'location',
        map: [
          {
            dest: 2408792839,
            from: 708984436,
            range: 12070437,
            to: 721054872,
          },
          {
            dest: 3916327360,
            from: 4103567762,
            range: 90492800,
            to: 4194060561,
          },
          {
            dest: 2136669394,
            from: 2902458135,
            range: 226099404,
            to: 3128557538,
          },
          {
            dest: 1414655297,
            from: 721054873,
            range: 722014097,
            to: 1443068969,
          },
          {
            dest: 2462136308,
            from: 3514619416,
            range: 2467233,
            to: 3517086648,
          },
          {
            dest: 1254861475,
            from: 3327498132,
            range: 98562162,
            to: 3426060293,
          },
          {
            dest: 2362768798,
            from: 569836962,
            range: 46024041,
            to: 615861002,
          },
          {
            dest: 4185175199,
            from: 3916327360,
            range: 8885363,
            to: 3925212722,
          },
          {
            dest: 421054090,
            from: 234463197,
            range: 201173738,
            to: 435636934,
          },
          {
            dest: 2497827912,
            from: 1550759989,
            range: 35404865,
            to: 1586164853,
          },
          {
            dest: 849065671,
            from: 0,
            range: 224309687,
            to: 224309686,
          },
          {
            dest: 37059832,
            from: 615861003,
            range: 93123433,
            to: 708984435,
          },
          {
            dest: 4006820160,
            from: 3925212723,
            range: 178355039,
            to: 4103567761,
          },
          {
            dest: 2863253575,
            from: 1705311678,
            range: 653833074,
            to: 2359144751,
          },
          {
            dest: 622227828,
            from: 1443068970,
            range: 107691019,
            to: 1550759988,
          },
          {
            dest: 2464603541,
            from: 2869233764,
            range: 33224371,
            to: 2902458134,
          },
          {
            dest: 1353423637,
            from: 3128557539,
            range: 61231660,
            to: 3189789198,
          },
          {
            dest: 1073375358,
            from: 3426060294,
            range: 47286090,
            to: 3473346383,
          },
          {
            dest: 2725544642,
            from: 3189789199,
            range: 137708933,
            to: 3327498131,
          },
          {
            dest: 26906322,
            from: 224309687,
            range: 10153510,
            to: 234463196,
          },
          {
            dest: 2420863276,
            from: 3473346384,
            range: 41273032,
            to: 3514619415,
          },
          {
            dest: 729918847,
            from: 1586164854,
            range: 119146824,
            to: 1705311677,
          },
          {
            dest: 2533232777,
            from: 2676921899,
            range: 192311865,
            to: 2869233763,
          },
          {
            dest: 0,
            from: 2359144752,
            range: 26906322,
            to: 2386051073,
          },
          {
            dest: 1120661448,
            from: 435636935,
            range: 134200027,
            to: 569836961,
          },
          {
            dest: 130183265,
            from: 2386051074,
            range: 290870825,
            to: 2676921898,
          },
        ],
      },
    ],
  };
}

function sample() {
  return {
    seeds: [
      {
        from: 55,
        range: 13,
        to: 67,
      },
      {
        from: 79,
        range: 14,
        to: 92,
      },
    ],
    maps: [
      {
        from: 'seed',
        to: 'soil',
        map: [
          {
            dest: 50,
            from: 98,
            range: 2,
            to: 99,
          },
          {
            dest: 52,
            from: 50,
            range: 48,
            to: 97,
          },
        ],
      },
      {
        from: 'soil',
        to: 'fertilizer',
        map: [
          {
            dest: 0,
            from: 15,
            range: 37,
            to: 51,
          },
          {
            dest: 37,
            from: 52,
            range: 2,
            to: 53,
          },
          {
            dest: 39,
            from: 0,
            range: 15,
            to: 14,
          },
        ],
      },
      {
        from: 'fertilizer',
        to: 'water',
        map: [
          {
            dest: 49,
            from: 53,
            range: 8,
            to: 60,
          },
          {
            dest: 0,
            from: 11,
            range: 42,
            to: 52,
          },
          {
            dest: 42,
            from: 0,
            range: 7,
            to: 6,
          },
          {
            dest: 57,
            from: 7,
            range: 4,
            to: 10,
          },
        ],
      },
      {
        from: 'water',
        to: 'light',
        map: [
          {
            dest: 88,
            from: 18,
            range: 7,
            to: 24,
          },
          {
            dest: 18,
            from: 25,
            range: 70,
            to: 94,
          },
        ],
      },
      {
        from: 'light',
        to: 'temperature',
        map: [
          {
            dest: 45,
            from: 77,
            range: 23,
            to: 99,
          },
          {
            dest: 81,
            from: 45,
            range: 19,
            to: 63,
          },
          {
            dest: 68,
            from: 64,
            range: 13,
            to: 76,
          },
        ],
      },
      {
        from: 'temperature',
        to: 'humidity',
        map: [
          {
            dest: 0,
            from: 69,
            range: 1,
            to: 69,
          },
          {
            dest: 1,
            from: 0,
            range: 69,
            to: 68,
          },
        ],
      },
      {
        from: 'humidity',
        to: 'location',
        map: [
          {
            dest: 60,
            from: 56,
            range: 37,
            to: 92,
          },
          {
            dest: 56,
            from: 93,
            range: 4,
            to: 96,
          },
        ],
      },
    ],
  };
}
