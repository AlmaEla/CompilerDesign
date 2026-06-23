%{
#include <stdio.h>
%}

%%

[0-9]+"+"[0-9]+"i"              { printf("Complex Number: %s\n", yytext); }
[0-9]+([eE][+-]?[0-9]+)         { printf("Exponential Number: %s\n", yytext); }
[0-9]+"."[0-9]+                 { printf("Float Number: %s\n", yytext); }
[0-9]+                          { printf("Integer Number: %s\n", yytext); }
[ \t\n]+                        ;
.                               ;

%%

int main() {
    printf("Enter number: ");
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
