%{
#include <stdio.h>
#include "y.tab.h"
%}
%option noyywrap


%%
"main" {return MAIN;}
"const" {return CONST;}
"int"|"float"|"char"|"string"|"bool" { return TYPE;}

"fn" {return FUNCTION;}
"->" {return ARROW;}
"return" {return RETURN;}

"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}

"class" {return CLASS;}
"private"|"protected"|"public" {return CLASS_SPEC;}
"." {return MEMBER_ACCESS;}


"!=" {return NEQ;}
"==" {return EQ;}
"<" {return LESS;}
"<=" {return LESSOREQ;}
">" {return GREATER;}
">=" {return GREATEROREQ;}

"++" {return INCREMENT;}
"--" {return DECREMENT;}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MULT;}
"/" {return SLASH;}
"%" {return REMAIDER; }

"&&" {return AND;}
"||" {return OR;}
"!" {return NEG;}

"=" {return ASSIGN;}

"true"|"false" { return BOOL; }
[a-zA-Z_][a-zA-Z0-9_]* { return ID; }


-?(([1-9][0-9]*)|0) { return NR; }
-?[0-9]+\.?[0-9]+ { return FLOAT; }
\".*\" { return STRING; }
\'.\' { return CHAR; }

[ \t] ;
\n {yylineno++;}
. {return yytext[0];}

%%
