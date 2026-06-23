"""
Program: Detect a Classic Ambiguous Grammar Pattern and Produce
         an Equivalent Unambiguous Grammar
Language: Python

IMPORTANT NOTE ON SCOPE
------------------------
Deciding whether an ARBITRARY context-free grammar is ambiguous is an
UNDECIDABLE problem in general (no algorithm can solve it for every
possible CFG). What this program does instead -- and what is normally
asked for in a compiler-construction course -- is:

  1. Detect the textbook-classic ambiguity pattern: a single
     non-terminal that is both left-recursive AND right-recursive on
     itself through more than one operator with no precedence/
     associativity rule, e.g.

         E -> E + E | E * E | ( E ) | id

     A grammar like this is ambiguous because a string such as
     "id + id * id" can be parsed in more than one way (two different
     parse trees), since the grammar gives no precedence between '+'
     and '*'.

  2. If that pattern is detected, automatically rewrite it into the
     standard layered/precedence-based UNAMBIGUOUS form, the same
     transformation taught in every compilers textbook:

         E  -> E + T | T
         T  -> T * F | F
         F  -> ( E ) | id

  3. If the grammar does NOT match this classic pattern, the program
     reports that no obvious ambiguity was detected by this heuristic
     (it does NOT claim the grammar is unambiguous -- that would
     require solving an undecidable problem).

Run: python3 9_cfg_ambiguity.py
"""

import re


def parse_grammar(text):
    grammar = {}
    order = []
    for line in text.strip().split("\n"):
        line = line.strip()
        if not line:
            continue
        head, body = line.split("->")
        head = head.strip()
        alternatives = [alt.strip().split() for alt in body.split("|")]
        if head not in grammar:
            grammar[head] = []
            order.append(head)
        grammar[head].extend(alternatives)
    return grammar, order


def find_self_recursive_operators(grammar, nonterminal):
    """
    For productions of the form  NT -> NT op NT, returns the set of
    operators 'op' that appear between two occurrences of the same
    non-terminal (this is the pattern that causes classic ambiguity).
    """
    operators = []
    for production in grammar[nonterminal]:
        if (len(production) == 3
                and production[0] == nonterminal
                and production[2] == nonterminal):
            operators.append(production[1])
    return operators


def detect_classic_ambiguity(grammar, order):
    """
    Looks for a non-terminal NT with two or more self-recursive
    alternatives  NT -> NT op1 NT | NT op2 NT | ...
    with no precedence distinction -- the classic ambiguous
    expression-grammar pattern.
    """
    for nt in order:
        ops = find_self_recursive_operators(grammar, nt)
        if len(ops) >= 2:
            return nt, ops
    return None, None


def build_unambiguous_expression_grammar(nt, ops, grammar):
    """
    Rebuilds the grammar using precedence layering.
    Operators given earlier in 'ops' are treated as LOWER precedence
    (matches the usual + / * example: + comes first in the input,
    so + gets lower precedence, * gets higher precedence -- mirroring
    how 'ops' is naturally listed for E -> E+E | E*E).
    """
    # collect the "atomic" (non-recursive) alternatives, e.g. ( E ) | id
    atomic = [p for p in grammar[nt]
              if not (len(p) == 3 and p[0] == nt and p[2] == nt)]

    # build one precedence layer per operator (lowest -> highest)
    layers = []
    prev_layer_name = None
    for i, op in enumerate(ops):
        layer_name = nt if i == 0 else f"{nt}{i}"
        layers.append((layer_name, op))

    new_grammar_lines = []
    n = len(layers)
    for i, (layer_name, op) in enumerate(layers):
        next_layer = layers[i + 1][0] if i + 1 < n else f"{nt}{n}"
        new_grammar_lines.append(f"{layer_name} -> {layer_name} {op} {next_layer} | {next_layer}")

    # the highest-precedence layer falls through to the atomic alternatives
    final_layer = f"{nt}{n}"
    atomic_str = " | ".join(" ".join(p) for p in atomic) if atomic else "id"
    new_grammar_lines.append(f"{final_layer} -> {atomic_str}")

    return new_grammar_lines


def main():
    print("Enter grammar productions (blank line to finish).")
    print("Example of an AMBIGUOUS grammar to try:")
    print("  E -> E + E | E * E | ( E ) | id")
    print()

    lines = []
    while True:
        line = input()
        if line.strip() == "":
            break
        lines.append(line)

    if not lines:
        lines = ["E -> E + E | E * E | ( E ) | id"]
        print("(No input given, using demo ambiguous grammar below)")
        for l in lines:
            print("  " + l)

    grammar_text = "\n".join(lines)
    grammar, order = parse_grammar(grammar_text)

    nt, ops = detect_classic_ambiguity(grammar, order)

    print("\nOriginal Grammar:")
    for l in lines:
        print("  " + l)

    if nt is not None:
        print(f"\nResult: The grammar IS AMBIGUOUS.")
        print(f"Reason: Non-terminal '{nt}' has multiple self-recursive")
        print(f"        alternatives with operators {ops} and no precedence")
        print(f"        rule between them (e.g. 'id + id * id' has two")
        print(f"        different parse trees).")

        new_lines = build_unambiguous_expression_grammar(nt, ops, grammar)
        print("\nEquivalent UNAMBIGUOUS Grammar (precedence-layered):")
        for l in new_lines:
            print("  " + l)
    else:
        print("\nResult: No classic ambiguity pattern detected by this")
        print("        heuristic check. (Note: this does NOT formally")
        print("        prove the grammar is unambiguous -- that problem")
        print("        is undecidable for general context-free grammars.)")


if __name__ == "__main__":
    main()
