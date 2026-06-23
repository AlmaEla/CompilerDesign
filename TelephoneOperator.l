%{
#include<stdio.h>
%}

%%

"013"[0-9]{8}    { printf("Grameenphone:%s\n",yytext); }
"014"[0-9]{8}    { printf("Banglalink\n"); }
"015"[0-9]{8}    { printf("Teletalk\n"); }
"016"[0-9]{8}    { printf("Airtel\n"); }
"017"[0-9]{8}    { printf("Grameenphone\n"); }
"018"[0-9]{8}    { printf("Robi\n"); }
"019"[0-9]{8}    { printf("Banglalink\n"); }

[0-9]+           { printf("Invalid Prefix\n"); }

\n               ;

%%

int yywrap()
{
    return 1;
}

int main()
{
    printf("Enter Mobile Number: ");
    yylex();
    return 0;
}
