%{
#include <stdio.h>
#include "y.tab.h"
%}


%option noyywrap

%%
"main" {return MAIN;}
"TypeOf" {return TYPEOF;}
"Eval" {return EVAL;}
"const" {return CONST;}
"int" {return INT; }
"float" {return FLOAT; }
"char" {return CHAR; }
"string" {return STRING; }
"bool" { return BOOL; }

"pr" {return PROCEDURE;}
"fn" {return FUNCTION;}
"->" {return ARROW;}
"return" {return RETURN;}

"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"for" {return FOR;}

"class" {return CLASS;}
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

"true"|"false" { yylval.valBOOL = (strcmp(yytext, "true") == 0); return BOOL_CONST; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.valSTRING = strdup(yytext); return ID; }


-?(([1-9][0-9]*)|0) { yylval.valINT = atoi(yytext); return INT_CONST; }
-?[0-9]+\.?[0-9]+ { yylval.valFLOAT = atof(yytext); return FLOAT_CONST; }
\"[^\"]*\" { yylval.valSTRING = strdup(yytext); return STRING_CONST; }
\'.\' { yylval.valCHAR = yytext[1]; return CHAR_CONST; }


"//".* {}
"/"\*(.*(\n)*)*\*"/"    {
                            char* p = yytext;

                            while(*p != '\0'){
                                if(*p == '\n')
                                    yylineno++;
                                ++p;
                            }
                        }

[ \t] ;
\n {yylineno++;}
. {return yytext[0];}



%%
