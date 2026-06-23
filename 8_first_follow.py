"""
Program: Calculate FIRST() and FOLLOW() of a given Context-Free Grammar
Language: Python

Grammar input format (edit GRAMMAR below, or type it in when prompted):
    Use '->' for production arrow
    Use '|' to separate alternatives
    Use 'eps' or 'e' for epsilon (empty string)
    Non-terminals: any uppercase letter / word
    Terminals: any lowercase word / symbol

Example grammar:
    E  -> T E'
    E' -> + T E' | eps
    T  -> F T'
    T' -> * F T' | eps
    F  -> ( E ) | id

Run:  python3 8_first_follow.py
"""

EPSILON = "eps"


def parse_grammar(text):
    """Parses grammar text into a dict: {NonTerminal: [ [symbols...], ... ]}"""
    grammar = {}
    order = []
    for line in text.strip().split("\n"):
        line = line.strip()
        if not line:
            continue
        head, body = line.split("->")
        head = head.strip()
        alternatives = [alt.strip().split() for alt in body.split("|")]
        # normalize epsilon spellings
        alternatives = [
            [EPSILON] if (alt == ["e"] or alt == ["eps"] or alt == ["epsilon"]) else alt
            for alt in alternatives
        ]
        if head not in grammar:
            grammar[head] = []
            order.append(head)
        grammar[head].extend(alternatives)
    return grammar, order


def is_terminal(symbol, grammar):
    return symbol not in grammar


def compute_first(grammar, order):
    first = {nt: set() for nt in order}

    changed = True
    while changed:
        changed = False
        for head in order:
            for production in grammar[head]:
                # FIRST of this production
                nullable_prefix = True
                for symbol in production:
                    if symbol == EPSILON:
                        if EPSILON not in first[head]:
                            first[head].add(EPSILON)
                            changed = True
                        nullable_prefix = False
                        break

                    if is_terminal(symbol, grammar):
                        if symbol not in first[head]:
                            first[head].add(symbol)
                            changed = True
                        nullable_prefix = False
                        break
                    else:
                        before = len(first[head])
                        first[head] |= (first[symbol] - {EPSILON})
                        if len(first[head]) != before:
                            changed = True
                        if EPSILON not in first[symbol]:
                            nullable_prefix = False
                            break
                if nullable_prefix:
                    if EPSILON not in first[head]:
                        first[head].add(EPSILON)
                        changed = True
    return first


def first_of_sequence(seq, first, grammar):
    """FIRST of a sequence of symbols (used for FOLLOW computation)."""
    result = set()
    nullable = True
    for symbol in seq:
        if symbol == EPSILON:
            continue
        if is_terminal(symbol, grammar):
            result.add(symbol)
            nullable = False
            break
        else:
            result |= (first[symbol] - {EPSILON})
            if EPSILON not in first[symbol]:
                nullable = False
                break
    if nullable:
        result.add(EPSILON)
    return result


def compute_follow(grammar, order, first, start_symbol):
    follow = {nt: set() for nt in order}
    follow[start_symbol].add("$")

    changed = True
    while changed:
        changed = False
        for head in order:
            for production in grammar[head]:
                for i, symbol in enumerate(production):
                    if symbol == EPSILON or is_terminal(symbol, grammar):
                        continue
                    rest = production[i + 1:]
                    rest_first = first_of_sequence(rest, first, grammar)

                    before = len(follow[symbol])
                    follow[symbol] |= (rest_first - {EPSILON})
                    if EPSILON in rest_first:
                        follow[symbol] |= follow[head]
                    if len(follow[symbol]) != before:
                        changed = True
    return follow


def print_sets(title, sets, order):
    print(f"\n{title}")
    print("-" * 40)
    for nt in order:
        values = sorted(sets[nt])
        print(f"{title[:5]}({nt}) = {{ {', '.join(values)} }}")


def main():
    print("Enter grammar productions (blank line to finish).")
    print("Format examples:")
    print("  E -> T E'")
    print("  E' -> + T E' | eps")
    print()

    lines = []
    while True:
        line = input()
        if line.strip() == "":
            break
        lines.append(line)

    if not lines:
        # fallback demo grammar if user enters nothing
        lines = [
            "E -> T E'",
            "E' -> + T E' | eps",
            "T -> F T'",
            "T' -> * F T' | eps",
            "F -> ( E ) | id",
        ]
        print("(No input given, using demo grammar below)")
        for l in lines:
            print("  " + l)

    grammar_text = "\n".join(lines)
    grammar, order = parse_grammar(grammar_text)
    start_symbol = order[0]

    first = compute_first(grammar, order)
    follow = compute_follow(grammar, order, first, start_symbol)

    print_sets("FIRST", first, order)
    print_sets("FOLLOW", follow, order)


if __name__ == "__main__":
    main()
