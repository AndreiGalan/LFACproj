%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"int"|"float"|"char"|"string"|"bool"|"undefined" {yylval.strval = strdup(yytext); return TYPE;}
"constant" {return CONST;}
"begin" {return BEGIN;}
"end" {return END;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}
"class" {return CLASS;}
"private"|"protected"|"public" {return CLASS_SPEC;}
"true"|"false" {return BOOL_VAL;}
"<" {return LESS;}
"<=" {return LESSOREQ;}
">" {return GREATER;}
">=" {return GREATEROREQ;}
"+" {return PLUS;}
"-" {return MINUS;}




"*" {return MULT;}
"/" {return SLASH;}
"&&" {return AND;}
"||" {return OR;}
"!" {return NEG;}
"strcpy"|"strcat" {return STR_OP;}
@[_a-zA-Z][_a-zA-Z0-9]* {yylval.strval = strdup(yytext); return ID;}
":=" {return ASSIGN;}
[1-9]+[0-9]* {yylval.val = atoi(yytext); return NR; }
0+[0-9]* {yylval.strval = strdup(yytext);return FLT;}
0 {yylval.val = atoi(yytext);return NR;}
"{" {return LB;}
"}" {return RB;}
EVAL {return EVAL;}
PRINT {return PRINT;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}