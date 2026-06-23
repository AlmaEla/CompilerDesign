# Lex / Compiler Construction Lab Programs

All 8 "lex program" tasks are written as standalone, strictly-correct
`.l` (Flex) source files. The 2 "any language" tasks are written in
Python, as requested.

## Files

| # | File | Task |
|---|------|------|
| 1 | `1_bd_telephone_operators.l` | Recognize telephone operators in Bangladesh |
| 2 | `2_count_chars_words_lines.l` | Count characters, words and lines in a C program |
| 3 | `3_identify_numbers.l` | Identify integer, floating point, exponential and complex numbers |
| 4 | `4_count_spaces_comments.l` | Identify and count spaces and comments in a C program |
| 5 | `5_count_identifiers.l` | Recognize and count all identifiers in a C program |
| 6 | `6_tobe_verbs.l` | Recognize "to be" verbs from a paragraph |
| 7 | `7_sentence_type.l` | Identify whether a sentence is simple / complex / compound |
| 8 | `8_first_follow.py` | Calculate FIRST() and FOLLOW() of a grammar (Python) |
| 9 | `9_cfg_ambiguity.py` | Detect CFG ambiguity and output an unambiguous grammar (Python) |
| 10 | `10_c_lexer.l` | Complete lexical analyzer for C programs |

All `.l` files have been compiled and test-run successfully with `flex` + `gcc`.

## How to compile and run a `.l` file

```bash
flex -o lex.yy.c <filename>.l
gcc lex.yy.c -o program -lfl
./program            # for interactive-input programs (1, 3, 6 typed paragraph, 7)
./program sample.c   # for programs that read a file (2, 4, 5, 6 with file, 10)
```

(If `-lfl` is not found on your system, try `-ll` instead, or compile
without it by adding `int yywrap(){return 1;}` — which is already
included in every file here, so plain `gcc lex.yy.c -o program` also works.)

## How to run a `.py` file

```bash
python3 8_first_follow.py
python3 9_cfg_ambiguity.py
```

Both will prompt you to type grammar productions (one per line, blank
line to finish). If you just press Enter immediately, each program
falls back to a built-in demo grammar so you can see sample output.

## Notes on individual programs

- **#1 Telephone operators**: matches Bangladeshi mobile numbers
  (`01[3-9]xxxxxxxx`, with or without `+880`/`880` country code) and
  prints the corresponding operator (Grameenphone, Robi, Banglalink,
  Airtel, Teletalk) based on the digit after `01`.
- **#5 Identifiers**: skips C keywords, string/char literals,
  comments, and preprocessor directives (`#include ...`) so only true
  identifiers are counted.
- **#7 Sentence type**: uses a simple heuristic — presence of a
  coordinating conjunction (and, but, or, so, ...) → Compound;
  presence of a subordinating conjunction (because, although, since,
  ...) → Complex; both → Compound-Complex; neither → Simple.
- **#9 CFG ambiguity**: general CFG ambiguity is an *undecidable*
  problem — no program can solve it for every possible grammar. This
  program detects the classic textbook ambiguity pattern (a
  non-terminal that is self-recursive through two or more operators
  with no precedence, e.g. `E -> E+E | E*E | id`) and automatically
  rewrites it into the standard precedence-layered unambiguous form.
