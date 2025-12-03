{ L: -1, R: 1 } as $m |

[inputs | [.[:1], (.[1:] | tonumber)]] | # parse and transform

[foreach .[] as $_ (
  50;
  (. + (
    100 + ($m[$_[0]] * $_[1])
  )) % 100;

    # 1. spins
    (($_[1] / 100) | floor) as $spin |

    # 2. remove 100s
    ($_[1] - 100 * $spin) as $value |

    # 2.5 undo the UPDATE logic
    (((100 + $m[$_[0]] * -1 * $_[1]) + .) % 100) as $prev |

    # 3. get the ticks
    ($prev + $value * $m[$_[0]]) as $ticks |

    # 4. logic
    if $ticks > 99 then
      1
    elif ($ticks <= 0 and $prev != 0) then
      1
    else
      0
    end |
    . + $spin
)] | add