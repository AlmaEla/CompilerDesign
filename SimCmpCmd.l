%{
#include<stdio.h>
int complex=0, compound=0;
%}

%%

.*(because|although|if|when|since).*   { printf("Complex Sentence\n"); complex=1; }

.*(and|or|but).*                       { printf("Compound Sentence\n"); compound=1; }

.*",".*                                { printf("Compound Sentence\n"); compound=1; }

.*                                     {
    if(complex==0 && compound==0)
        printf("Simple Sentence\n");
}

%%

int main()
{
    printf("Enter sentence:\n");
    yylex();
    return 0;
}

int yywrap()
{
    return 1;
}
