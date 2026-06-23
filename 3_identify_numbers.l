/* ============================================================
   Lex Program: Identify Integer, Floating Point, Exponential
                and Complex Numbers
   Compile : flex 3_identify_numbers.l
             gcc lex.yy.c -o numbers -lfl
   Run     : ./numbers
   Examples: 25        -> Integer
             3.14      -> Floating Point
             2.5e10    -> Exponential
             3+4i      -> Complex
   ============================================================ */

%{
#include <stdio.h>
%}

DIGIT       [0-9]
INTEGER     {DIGIT}+
FLOATNUM    {DIGIT}+"."{DIGIT}+
EXPONENT    ({INTEGER}|{FLOATNUM})[eE][+-]?{INTEGER}
COMPLEXNUM  ({INTEGER}|{FLOATNUM})[+-]({INTEGER}|{FLOATNUM})"i"

%%
{COMPLEXNUM}    { printf("%-15s : Complex Number\n", yytext); }
{EXPONENT}      { printf("%-15s : Exponential Number\n", yytext); }
{FLOATNUM}      { printf("%-15s : Floating Point Number\n", yytext); }
{INTEGER}       { printf("%-15s : Integer Number\n", yytext); }
[ \t]            ;
\n               ;
.                { printf("%-15s : Not a Number\n", yytext); }
%%

int yywrap() { return 1; }

int main() {
    printf("Enter numbers (Ctrl+D to stop):\n");
    yylex();
    return 0;
}
