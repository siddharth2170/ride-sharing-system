# Statistics Across Programming Paradigms

This assignment calculates the mean, median, and mode of the same integer list
using procedural C, functional OCaml, and object-oriented Python.

## Run the programs

```bash
mkdir -p build
gcc -std=c11 -Wall -Wextra -Wpedantic c/statistics.c -o build/statistics_c
./build/statistics_c

ocamlc -o build/statistics_ocaml ocaml/statistics.ml
./build/statistics_ocaml

python3 python/statistics_calculator.py
python3 -m unittest discover -s python -p 'test_*.py'
```

The sample list is `4 1 2 2 3 4 4 5`. Its mean is `3.12`, median is
`3.50`, and mode is `4` when displayed to two decimal places.
