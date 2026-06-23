/* ============================================================
   Lex Program: Identify whether a Given Sentence is
                Simple / Complex / Compound
   Logic   : - A coordinating conjunction (and, but, or, so, ...)
               joining two independent clauses => Compound
             - A subordinating conjunction (because, although, ...)
               => Complex
             - Both kinds present => Compound-Complex
             - Neither present    => Simple
   Compile : flex 7_sentence_type.l
             gcc lex.yy.c -o sentencetype -lfl
   Run     : ./sentencetype
   ============================================================ */

%{
#include <stdio.h>

int coordinating = 0;
int subordinating = 0;
%}

%%
"and"|"but"|"or"|"nor"|"for"|"so"|"yet"   { coordinating++; }

"because"|"although"|"since"|"unless"|"while"|"if"|"when"|"though"|"after"|"before"|"as"|"that"|"whereas"|"until"   { subordinating++; }

[a-zA-Z]+    ;
[ \t]         ;
.             ;
\n            ;
%%

int yywrap() { return 1; }

int main() {
    printf("Enter a sentence (end with Ctrl+D):\n");
    yylex();

    if (subordinating > 0 && coordinating > 0)
        printf("\nResult: Compound-Complex Sentence\n");
    else if (subordinating > 0)
        printf("\nResult: Complex Sentence\n");
    else if (coordinating > 0)
        printf("\nResult: Compound Sentence\n");
    else
        printf("\nResult: Simple Sentence\n");

    return 0;
}
