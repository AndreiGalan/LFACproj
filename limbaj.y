%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

%}

%token TYPE SINGLECHAR CONST BEGIN_BLOC END_BLOC IF ELSE WHILE FOR CLASS 
	CLASS_SPEC BOOL_TRUE BOOL_FALSE LESS LESSOREQ GREATER GREATEROREQ PLUS 
	MINUS MULT SLASH AND OR NEG STR_OP ID ASSIGN FLOAT NR LB RB
	STRING RETURN MAIN

%start program

%right ASSIGN
%left PLUS MINUS
%left MULT SLASH
%left LESS GREATER LESSOREQ GREATEROREQ
%left OR
%left AND
%left NEG


%%
program			: declarations blocks MAIN_BLOC {printf("program corect sintactic\n");}
				;

blocks 			: functions blocks
				| procedures blocks
				| 
				;

MAIN_BLOC 		: MAIN {printf("main\n");} LB statements RB
     			;

declarations	: declaration ';'
				| declarations declaration ';'
				;

declaration 	: ISCONT TYPE ID
				| ISCONT TYPE ID '[' NR ']'
				;

functions 		: functions function
        		| function
        		;

function		: TYPE ID '(' params ')' LB statements rtn RB
        		| TYPE ID '(' ')' LB statements rtn RB
        		;

rtn 			: RETURN ID ';'
				| RETURN constant_value ';'
				;

constant_value	: NR
				| FLOAT
				| STRING
				| SINGLECHAR
				| BOOL_TRUE
				| BOOL_FALSE	
				;

procedures 		: procedures procedure
        		| procedure
        		;

procedure 		: ID '(' params ')' LB statements RB
				| ID '(' ')' LB statements RB
				;

params 			: declaration ',' params
       			| declaration
       			;

statements		: statement ';'
      			| statements statement ';'
				| 
      			;


statement		: ID ASSIGN constant_value
				| declaration
				;
        
ISCONT 			: CONST
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