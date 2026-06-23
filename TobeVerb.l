%{
#include <stdio.h>

int count = 0;
%}

%%

"is"|"am"|"are"|"was"|"were"|"be"|"being"|"been" {
    printf("To be verb: %s\n", yytext);
    count++;
}

[ \t\n]+ ;

. ;

%%

int main() {
    yylex();
    printf("Total 'to be' verbs: %d\n", count);
    return 0;
}

int yywrap() {
    return 1;
}
