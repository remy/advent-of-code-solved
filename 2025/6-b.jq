def mul: reduce .[] as $_ (1; . * $_);

# parse
[inputs | trim | split("\\s+";null)]