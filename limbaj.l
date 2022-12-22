%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"int"|"float"|"char"|"string"|"bool"|"undefined" {yylval.valSTRING = strdup(yytext); return TYPE;}
\'[a-zA-Z0-9]\' { return SINGLECHAR; } 
"constant" {return CONST;}
"begin" {return BEGIN;}
"end" {return END;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}
"class" {return CLASS;}
"private"|"protected"|"public" {return CLASS_SPEC;}
"true" { return TRUE; }
"false" { return FALSE; }
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
":=" {return ASSIGN;}
[a-zA-Z][a-zA-Z0-9]* { yylval.valSTRING = strdup(yytext); return ID; }
[1-9]+[0-9]* {yylval.valINT = atoi(yytext); return NR; }
[1-9][0-9]*"\."[0-9]+ { yylval.valFLOAT = atof(yytext); return FLOAT; }
0 {yylval.valINT = atoi(yytext);return NR;}
\"[a-zA-Z0-9]*\" { yylval.valSTRING = strdup(yytext); return STRING; } 
"{" {return LB;}
"}" {return RB;}
EVAL {return EVAL;}
PRINT {return PRINT;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

%%