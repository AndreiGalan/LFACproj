%{
#include <stdio.h>
#include "includes.h"
#include <string.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

struct Variable* global_variables[100];
int curr_pos = 0;

%}

%union 
{ 
  int valINT;
  float valFLOAT;
  char valCHAR;
  char* valSTRING;
  int valBOOL;
  union Value* valEXPR;
  struct Variable* variable;
}


%token 	MAIN CONST
		INT FLOAT STRING CHAR BOOL
		FUNCTION ARROW RETURN 
		IF ELSE WHILE FOR
		CLASS CLASS_SPEC MEMBER_ACCESS
		NEQ EQ LESS LESSOREQ GREATER GREATEROREQ
		INCREMENT DECREMENT PLUS MINUS MULT SLASH PLUSA MINUSA MULTA SLASHA REMAIDER
		AND OR NEG
		ASSIGN 

%token <valINT> INT_CONST
%token <valFLOAT> FLOAT_CONST
%token <valCHAR> CHAR_CONST
%token <valSTRING> STRING_CONST ID
%token <valBOOL> BOOL_CONST

%type <variable> declaration definition constant_value operations item
%type <valINT> TYPE

%start program

%right ASSIGN MULTA SLASHA PLUSA MINUSA
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
program			: prog_parts MAIN_BLOC {printf("program corect sintactic\n");
										for(int i = 0; i < curr_pos; ++i)
											free(global_variables[i]);
										}
				;

prog_parts 		: prog_parts function
				| prog_parts declaration ';' 	{
													global_variables[curr_pos++] = $2;
													printf("%d\n", curr_pos);
													printf("%s\n", global_variables[curr_pos-1]->name);
													printf("%d\n", global_variables[curr_pos-1]->type);
													fflush(stdout);
												}
				| prog_parts definition ';'		{
													global_variables[curr_pos++] = $2;
													printf("%d\n", curr_pos);
													printf("%s\n", global_variables[curr_pos-1]->name);
													printf("%d\n", global_variables[curr_pos-1]->type);
													fflush(stdout);
												}
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
				| function_block function_call ';'
				| function_block while
				| function_block for
				| function_block if
				|
				;

rtn 			: RETURN ID ';'
				| RETURN item ';'
				;
function_call   : FUNCTION ID '(' params_call ')' 
				;



params_call     : operations ',' params_call 
				| operations 
				|
				;

/*DECLARATION DEFINITION*/
declaration 	: TYPE ID 								{
															$$ = (struct Variable*)malloc(sizeof(struct Variable));
															strcpy($$->name, $2);
															$$->type = $1;
															$$->is_const = 0;
															$$->value.valINT = 0;
														}
				| TYPE ID '[' INT_CONST ']' 
				; 

definition  	: CONST TYPE ID ASSIGN constant_value 	{
															$$ = $5;
															strcpy($$->name, $3);
															$$->is_const = 1;
														}
				| TYPE ID ASSIGN constant_value			{
															$$ = $4;
															strcpy($$->name, $2);
															$$->is_const = 0;
														}
				| CONST TYPE ID '[' INT_CONST ']' ASSIGN '{' constant_values '}'
				| TYPE ID '[' INT_CONST ']' ASSIGN '{' constant_values '}'
				;

TYPE 			: INT {$$ = INT;}
				| FLOAT {$$ = FLOAT;}
				| STRING {$$ = STRING;}
				| CHAR {$$ = CHAR;}
				| BOOL {$$ = BOOL;}
				;

constant_values : constant_value
				| constant_values ',' constant_value
				;

constant_value	: INT_CONST 	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									strcpy($$->name, "@const");
									$$->type = INT;
									$$->value.valINT = $1;
								}
				| FLOAT_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									strcpy($$->name, "@const");
									$$->type = FLOAT;
									$$->value.valFLOAT = $1;
								}
				| STRING_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									strcpy($$->name, "@const");
									$$->type = STRING;
									strcpy($$->value.valSTRING, $1);
								}
				| CHAR_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									strcpy($$->name, "@const");
									$$->type = CHAR;
									$$->value.valCHAR = $1;
								}
				| BOOL_CONST 	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									strcpy($$->name, "@const");
									$$->type = BOOL;
									$$->value.valBOOL = $1;
								}
				;

assignments		: assignment ';'
      			| assignments assignment ';'
				| 
      			;

shortcuts		: PLUSA
				| MINUSA
				| MULTA
				| SLASHA
				;

assignment		: ID ASSIGN item
				| ID ASSIGN operations
				| ID shortcuts item
				| ID shortcuts operations
				| ID INCREMENT
				| ID DECREMENT
				;


operations 		: item {$$ = $1;}
				| operations PLUS operations 	{
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													strcpy($$->name, "@const");
													if($1->type == INT && $3->type == INT ){
														$$->type = INT;
														$$->value.valINT = $1->value.valINT + $3->value.valINT;
													}
													if(($1->type == FLOAT && $3->type == FLOAT) || ($1->type == FLOAT && $3->type == INT) || ($1->type == INT && $3->type == FLOAT)){
														$$->type = FLOAT;
														$$->value.valFLOAT = (($1->type == INT)? $1->value.valINT : $1->value.valFLOAT) + (($3->type == INT)? $3->value.valINT : $3->value.valFLOAT);
													}

												}
				| operations MINUS operations
				| operations SLASH operations
				| operations MULT operations
				| '(' operations ')'
				;

/*Control flow statements*/
bool_statement 	: bool_expresion
				| bool_statement AND bool_statement
				| bool_statement OR bool_statement
				| NEG bool_statement
				;

bool_expresion	: item NEQ item
				| item EQ item
				| item LESS item
				| item LESSOREQ item
				| item GREATER item
				| item GREATEROREQ item
				| BOOL
				;

item            : ID {$$ = 1000;}
				| constant_value
				;
				

while  			: WHILE '(' bool_statement ')' '{' function_block '}'
				;

for				: FOR '(' definition ';' bool_statement ';' assignment ')' '{' function_block '}'
				| FOR '(' assignment ';' bool_statement ';' assignment ')' '{' function_block '}'
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