%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap


%%
"int"|"float"|"char"|"string"|"bool" { return TYPE;}
"const" {return CONST;}
"begin:" {return BEGIN_BLOC;}
"end;" {return END_BLOC;}
"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}
"class" {return CLASS;}
"private"|"protected"|"public" {return CLASS_SPEC;}


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

":=" {return ASSIGN;}

[a-zA-Z_][a-zA-Z0-9_]* { return ID; }
-?(([1-9][0-9]*)|0) { return NR; }
-?[0-9]+\.?[0-9]+ { return FLOAT; }

\".*\" { return STRING; }
\'.\' { return SINGLECHAR; }
"true" { return BOOL_TRUE; }
"false" { return BOOL_FALSE; } 
"{" {return LB;}
"}" {return RB;}

[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

%%