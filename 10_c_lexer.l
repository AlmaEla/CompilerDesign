/* ============================================================
   Lex Program: Complete Lexical Analyzer for C Programs
   Recognizes: keywords, identifiers, integer/float constants,
               character constants, string literals, operators,
               punctuation, comments (skipped) and preprocessor
               directives.
   Compile : flex 10_c_lexer.l
             gcc lex.yy.c -o clexer -lfl
   Run     : ./clexer sample.c
   ============================================================ */

%{
#include <stdio.h>

int line_number = 1;
%}

DIGIT       [0-9]
LETTER      [a-zA-Z_]
ID          {LETTER}({LETTER}|{DIGIT})*
INTCONST    {DIGIT}+
FLOATCONST  {DIGIT}+"."{DIGIT}+([eE][+-]?{DIGIT}+)?
HEXCONST    0[xX][0-9a-fA-F]+
CHARCONST   '([^'\\]|\\.)'
STRCONST    \"([^"\\]|\\.)*\"

%%

"#"[a-zA-Z]+[ \t]*[<\"][^>\"\n]*[>\"]?    { printf("PREPROCESSOR : %s\n", yytext); }
"#"[a-zA-Z]*                              { printf("PREPROCESSOR : %s\n", yytext); }

"/*"([^*]|"*"+[^*/])*"*"+"/"   { /* block comment, skipped, count newlines for line tracking */
                                  int i; for(i=0;yytext[i];i++) if(yytext[i]=='\n') line_number++; }
"//".*                          { /* line comment, skipped */ }

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"   { printf("KEYWORD      : %s\n", yytext); }

{HEXCONST}      { printf("HEX CONST    : %s\n", yytext); }
{FLOATCONST}    { printf("FLOAT CONST  : %s\n", yytext); }
{INTCONST}      { printf("INT CONST    : %s\n", yytext); }
{CHARCONST}     { printf("CHAR CONST   : %s\n", yytext); }
{STRCONST}      { printf("STRING       : %s\n", yytext); }
{ID}            { printf("IDENTIFIER   : %s\n", yytext); }

"<<="|">>="|"<="|">="|"=="|"!="|"&&"|"||"|"++"|"--"|"->"|"+="|"-="|"*="|"/="|"%="|"&="|"|="|"^="|"<<"|">>"   { printf("OPERATOR     : %s\n", yytext); }
[+\-*/%=<>!&|^~?:]    { printf("OPERATOR     : %s\n", yytext); }

[;,{}()\[\].]   { printf("PUNCTUATION  : %s\n", yytext); }

\n              { line_number++; }
[ \t]+          ;
.               { printf("UNKNOWN TOKEN: %s\n", yytext); }

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

    printf("\nTotal lines scanned: %d\n", line_number);

    return 0;
}
