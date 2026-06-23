/* 02. Write a lex program to count the characters, words and lines in a given C program. */

%{ 
#include <stdio.h> 
int char_count = 0, word_count = 0, line_count = 0; 
%} 
%% 
[a-zA-Z0-9_]+ { word_count++; char_count += yyleng; } 
\n { char_count++; line_count++; } 
. { char_count++; } 
%% 
int yywrap() { 
    return 1; 
} 
int main() { 
    yylex(); 
    printf("Characters: %d\nWords: %d\nLines: %d\n", char_count, 
word_count, line_count); 
    return 0; 
}