%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

%}

%token 	MAIN CONST TYPE ID 
		FUNCTION ARROW RETURN 
		IF ELSE WHILE FOR
		CLASS CLASS_SPEC MEMBER_ACCESS
		NEQ EQ LESS LESSOREQ GREATER GREATEROREQ
		INCREMENT DECREMENT PLUS MINUS MULT SLASH REMAIDER
		AND OR NEG
		ASSIGN 
		NR FLOAT STRING CHAR BOOL

%start program

%right ASSIGN
%left OR
%left AND
%left EQ NEQ
%left LESS GREATER LESSOREQ GREATEROREQ
%left PLUS MINUS
%left MULT SLASH REMAIDER
%left NEG
%left INCREMENT DECREMENT
%left MEMBER_ACCESS


%%
program			: prog_parts MAIN_BLOC {printf("program corect sintactic\n");}
				;

prog_parts 		: prog_parts function
				| prog_parts declaration ';'
				| prog_parts definition ';'
				| prog_parts class
				|
				;

MAIN_BLOC 		: MAIN {printf("main\n");} '{' function_block '}'
     			;

/* CLASS */
class			: CLASS ID '{' class_block '}'
				;

class_block		: class_block CLASS_SPEC function
				| class_block CLASS_SPEC declaration ';'
				| class_block CLASS_SPEC definition ';'
				| 
				;

/*FUNCTION*/

function		: FUNCTION ID '(' params ')' ARROW TYPE '{' function_block rtn '}'
        		| FUNCTION ID '(' params ')' '{' function_block '}'
        		;

params 			: declaration ',' params
       			| declaration
				|
       			;

function_block 	: function_block assignments 
				| function_block declaration ';'
				| function_block definition ';'
				| function_block while
				| function_block for
				| function_block if
				|
				;

rtn 			: RETURN ID ';'
				| RETURN constant_value ';'
				;


/*DECLARATION DEFINITION*/
declaration 	: TYPE ID 
				| TYPE ID '[' NR ']' 
				; 

definition  	: CONST TYPE ID ASSIGN constant_value
				| TYPE ID ASSIGN constant_value
				| CONST TYPE ID '[' NR ']'
				| TYPE ID '[' NR ']'
				;


constant_value	: NR
				| FLOAT
				| STRING
				| CHAR
				| BOOL	
				;

assignments		: assignment ';'
      			| assignments assignment ';'
				| 
      			;


assignment		: ID ASSIGN constant_value
				;
        
/*Control flow statements*/
bool_statement 	: bool_expresion
				| bool_statement AND bool_statement
				| bool_statement OR bool_statement
				| NEG bool_statement
				;

bool_expresion	: BOOL NEQ BOOL
				| BOOL EQ BOOL
				| BOOL LESS BOOL
				| BOOL LESSOREQ BOOL
				| BOOL GREATER BOOL
				| BOOL GREATEROREQ BOOL
				| BOOL
				;

while  			: WHILE '(' bool_statement ')' '{' function_block '}'
				;

for				: FOR '(' definition ';' bool_statement ';' ')' '{' function_block '}'
				| FOR '(' assignment ';' bool_statement ';' ')' '{' function_block '}'
				;

if 				: IF '(' bool_statement ')' '{' function_block '}'
				| IF '(' bool_statement ')' '{' function_block '}' ELSE '{' function_block '}'
				;
%%


int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 