/* ============================================================
   Lex Program: Recognize "To Be" Verbs from a Given Paragraph
   Compile : flex 6_tobe_verbs.l
             gcc lex.yy.c -o tobeverbs -lfl
   Run     : ./tobeverbs paragraph.txt
   ============================================================ */

%{
#include <stdio.h>

int count = 0;
%}

%%
("am"|"Am"|"AM")           { count++; printf("To-be verb found: %s\n", yytext); }
("is"|"Is"|"IS")            { count++; printf("To-be verb found: %s\n", yytext); }
("are"|"Are"|"ARE")         { count++; printf("To-be verb found: %s\n", yytext); }
("was"|"Was"|"WAS")         { count++; printf("To-be verb found: %s\n", yytext); }
("were"|"Were"|"WERE")      { count++; printf("To-be verb found: %s\n", yytext); }
("be"|"Be"|"BE")             { count++; printf("To-be verb found: %s\n", yytext); }
("being"|"Being"|"BEING")   { count++; printf("To-be verb found: %s\n", yytext); }
("been"|"Been"|"BEEN")       { count++; printf("To-be verb found: %s\n", yytext); }
[a-zA-Z]+                    ;   /* any other word, ignored */
.                              ;
\n                             ;
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

    printf("\nTotal 'to be' verbs found: %d\n", count);

    return 0;
}
