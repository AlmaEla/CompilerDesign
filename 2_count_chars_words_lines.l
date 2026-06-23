/* ============================================================
   Lex Program: Count Characters, Words and Lines in a C Program
   Compile : flex 2_count_chars_words_lines.l
             gcc lex.yy.c -o counter -lfl
   Run     : ./counter sample.c
   ============================================================ */

%{
#include <stdio.h>
#include <string.h>

int char_count = 0;
int word_count = 0;
int line_count = 0;
%}

%%
\n              { line_count++; char_count++; }
[^ \t\n]+       { word_count++; char_count += strlen(yytext); }
[ \t]           { char_count++; }
%%

int yywrap() { return 1; }

int main(int argc, char *argv[]) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            printf("Cannot open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }

    yylex();

    /* if the file does not end with a newline, the last line is still a line */
    if (char_count > 0 && line_count == 0)
        line_count = 1;

    printf("Characters : %d\n", char_count);
    printf("Words      : %d\n", word_count);
    printf("Lines      : %d\n", line_count);

    return 0;
}
