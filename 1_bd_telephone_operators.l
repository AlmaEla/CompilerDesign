/* ============================================================
   Lex Program: Recognize Telephone Operators in Bangladesh
   Compile : flex 1_bd_telephone_operators.l
             gcc lex.yy.c -o operator -lfl
   Run     : ./operator
   Input   : type numbers like 01712345678 or +8801912345678
             press Ctrl+D to end input
   ============================================================ */

%{
#include <stdio.h>
#include <string.h>

void check_operator(char *text);
%}

DIGIT [0-9]

%%
"+880"[-]?"1"[3-9]{DIGIT}{8}    { check_operator(yytext); }
"880"[-]?"01"[3-9]{DIGIT}{8}    { check_operator(yytext); }
"01"[3-9]{DIGIT}{8}             { check_operator(yytext); }
[ \t]                            ;
\n                                ;
.                                 ;
%%

void check_operator(char *text) {
    char digits[20];
    int i, j = 0, len = strlen(text);

    /* keep only digits, so +880-17... and 01712... are handled uniformly */
    for (i = 0; i < len; i++) {
        if (text[i] >= '0' && text[i] <= '9')
            digits[j++] = text[i];
    }
    digits[j] = '\0';

    /* locate the "01" pattern -- the digit right after it is the operator code */
    char *pos = strstr(digits, "01");
    char code = pos[2];

    printf("%-18s -> ", text);
    switch (code) {
        case '3':
        case '7':
            printf("Grameenphone\n");
            break;
        case '8':
            printf("Robi\n");
            break;
        case '9':
            printf("Banglalink\n");
            break;
        case '6':
            printf("Airtel\n");
            break;
        case '5':
            printf("Teletalk\n");
            break;
        case '4':
            printf("Banglalink (old Citycell band)\n");
            break;
        default:
            printf("Unknown Operator\n");
    }
}

int yywrap() { return 1; }

int main() {
    printf("Enter phone numbers (Ctrl+D to stop):\n");
    yylex();
    return 0;
}
