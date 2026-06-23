/* ============================================================
   Lex Program: Identify and Count Spaces and Comments
                in a Given C Program
   Compile : flex 4_count_spaces_comments.l
             gcc lex.yy.c -o spacescomments -lfl
   Run     : ./spacescomments sample.c
   ============================================================ */

%{
#include <stdio.h>

int space_count = 0;
int comment_count = 0;
%}

%%
"/*"([^*]|"*"+[^*/])*"*"+"/"   { comment_count++; }
"//".*                          { comment_count++; }
[ \t]                            { space_count++; }
\n                                ;
.                                 ;
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

    printf("Total Spaces   : %d\n", space_count);
    printf("Total Comments : %d\n", comment_count);

    return 0;
}
