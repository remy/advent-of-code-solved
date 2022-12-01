def parse: split(",") | map(tonumber) | { min: min, max: max, all: . };

parse | . as $_ |
[foreach range($_.min; $_.max) as $target (
  .;
  .;
  $_.all | map($target - . | fabs) | add
)] | min
