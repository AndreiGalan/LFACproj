%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

%}

%token TYPE SINGLECHAR CONST BEGIN_BLOC END_BLOC IF ELSE WHILE FOR CLASS 
	CLASS_SPEC BOOL_TRUE BOOL_FALSE LESS LESSOREQ GREATER GREATEROREQ PLUS 
	MINUS MULT SLASH AND OR NEG STR_OP ID ASSIGN FLOAT NR LB RB
	STRING

%start program

%right ASSIGN
%left '+' '-'
%left '*' '/'
%left '<' '>' "<=" ">="
%left "||"
%left "&&"
%left '!'
%%
program		: declaratii bloc {printf("program corect sintactic\n");}
			| bloc
     		;

declaratii 	: declaratie ';'
	   		| declaratii declaratie ';'
	   		;

declaratie 	: ISCONT TYPE ID
			| ISCONT TYPE ID '[' NR ']'
           	;

bloc 		: BEGIN_BLOC {printf("main\n");}  statements END_BLOC 
     		;

statements	: statement ';'
      		| statements statement ';'
      		;


statement	: ID ASSIGN ID
         	| ID ASSIGN NR
			| ID ASSIGN FLOAT
			| ID ASSIGN STRING	
			| ID ASSIGN SINGLECHAR
			| ID ASSIGN BOOL_TRUE
			| ID ASSIGN BOOL_FALSE	
			| declaratie
         	;
        
ISCONT 		: CONST
			| 
			;

%%


int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 