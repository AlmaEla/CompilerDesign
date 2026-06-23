%{
#include <stdio.h>

int spaces = 0;
int comments = 0;
%}

%%

"//".*                          { comments++; }
"/*"([^*]|\*+[^*/])*\*+"/"      { comments++; }

[ ]                             { spaces++; }

[\t\n]+                         ;

.                               ;

%%

int main() {
    yylex();
    printf("Spaces: %d\n", spaces);
    printf("Comments: %d\n", comments);
    return 0;
}

int yywrap() {
    return 1;
}
