/* ============================================================
   Lex Program: Recognize and Count All Identifiers
                in a C Program
   Compile : flex 5_count_identifiers.l
             gcc lex.yy.c -o identifiers -lfl
   Run     : ./identifiers sample.c
   ============================================================ */

%{
#include <stdio.h>
#include <string.h>

int id_count = 0;

char *keywords[] = {
    "auto","break","case","char","const","continue","default","do",
    "double","else","enum","extern","float","for","goto","if","int",
    "long","register","return","short","signed","sizeof","static",
    "struct","switch","typedef","union","unsigned","void","volatile","while"
};
int num_keywords = 32;

int is_keyword(char *s) {
    int i;
    for (i = 0; i < num_keywords; i++) {
        if (strcmp(s, keywords[i]) == 0)
            return 1;
    }
    return 0;
}
%}

%%
"#".*           ;   /* skip preprocessor directives, e.g. #include <stdio.h> */
[a-zA-Z_][a-zA-Z0-9_]*   {
    if (!is_keyword(yytext)) {
        id_count++;
        printf("Identifier %2d : %s\n", id_count, yytext);
    }
}
\".*\"          ;   /* skip string literals */
'.'             ;   /* skip char literals */
"/*"([^*]|"*"+[^*/])*"*"+"/"   ;  /* skip block comments */
"//".*          ;   /* skip line comments */
.               ;
\n              ;
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

    printf("\nTotal Identifiers Found: %d\n", id_count);

    return 0;
}
