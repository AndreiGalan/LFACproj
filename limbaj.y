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
%type <valINT> TYPE shortcuts
%type <valBOOL> bool_expresion bool_statement

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
program			: prog_parts MAIN_BLOC 	{
											printf("program corect sintactic\n");
											for(int i = 0; i < curr_pos; ++i){
												printf("%d\n", global_variables[i]->value.valINT);
												free(global_variables[i]);
											}
										}
				;

prog_parts 		: prog_parts function
				| prog_parts declaration ';' 	{
													global_variables[curr_pos++] = $2;
											
													printf("%s\n", global_variables[curr_pos-1]->name);
													printf("%d\n", global_variables[curr_pos-1]->value.valBOOL);
													fflush(stdout);
												}
				| prog_parts definition ';'		{
													global_variables[curr_pos++] = $2;
									
													printf("%s\n", global_variables[curr_pos-1]->name);
													printf("%d\n", global_variables[curr_pos-1]->value.valBOOL);
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
declaration 	: 
				  TYPE ID 								{
															$$ = (struct Variable*)malloc(sizeof(struct Variable));
															strcpy($$->name, $2);
															$$->type = $1;
															$$->is_const = 0;
															$$->value.valINT = 0;
														}
				| TYPE ID '[' INT_CONST ']' 
				; 

definition  	: 
				  CONST TYPE ID ASSIGN operations 		{
															if($2 != $5->type){
																printf("eroare la linia:%d\n", yylineno);
        														exit(1);
															}

															if(strcmp($5->name, "@const") == 0){
																$$ = $5;
																strcpy($$->name, $3);
																$$->is_const = 1;
															}
															else{
																$$ = (struct Variable*)malloc(sizeof(struct Variable));
																strcpy($$->name, $3);
																$$->type = $2;
																$$->is_const = 1;

																if($2 == STRING){
																	$$->value.valSTRING = (char*)malloc((strlen($5->value.valSTRING) + 1) * sizeof(char));
																	strcpy($$->value.valSTRING, $5->value.valSTRING);
																}
																else{
																	$$->value.valINT = 0;
																	memcpy(&$$->value, &$5->value, sizeof($5->value)); 
																}

															}
														}
				| TYPE ID ASSIGN operations				{
															if($1 != $4->type){
																printf("eroare la linia:%d\n", yylineno);
        														exit(1);
															}

															if(strcmp($4->name, "@const") == 0){
																$$ = $4;
																strcpy($$->name, $2);
																$$->is_const = 0;
															}
															else{
																$$ = (struct Variable*)malloc(sizeof(struct Variable));
																strcpy($$->name, $2);
																$$->type = $1;
																$$->is_const = 0;

																if($1 == STRING){
																	$$->value.valSTRING = (char*)malloc((strlen($4->value.valSTRING) + 1) * sizeof(char));
																	strcpy($$->value.valSTRING, $4->value.valSTRING);
																}
																else{
																	$$->value.valINT = 0;
																	memcpy(&$$->value, &$4->value, sizeof($4->value)); 
																}

															}
														}
				| CONST TYPE ID '[' INT_CONST ']' ASSIGN '{' operations '}'
				| TYPE ID '[' INT_CONST ']' ASSIGN '{' operations '}'
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

constant_value	: 
				  INT_CONST 	{
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
									$$->value.valSTRING = (char*)malloc((strlen($1) - 1) * sizeof(char));
									$1[strlen($1) - 1] = '\0';
									strcpy($$->value.valSTRING, $1 + 1);
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

shortcuts		: PLUSA 	{$$ = PLUSA;}
				| MINUSA	{$$ = MINUSA;}
				| MULTA		{$$ = MULTA;}
				| SLASHA	{$$ = SLASHA;}
				;

assignment		: 
				  ID ASSIGN item 			{
												struct Variable* v = NULL;
												for(int i=0;i<curr_pos;i++)
													if(strcmp(global_variables[i]->name,$1)==0)
														v = global_variables[i];

												if(v == NULL || v->is_const == 1){
													if(strcmp($3->name, "@const") == 0)
														free($3);
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared or is const!!!\n");
													exit(1);
												}

												if(v->type != $3->type){
													if(strcmp($3->name, "@const") == 0)
														free($3);
													printf("Error at line: %d\n", yylineno);
													printf("The types are not compatible!!!\n");
													exit(1);
												}
											
												if(v->type == STRING){
													v->value.valSTRING = (char*)malloc((strlen($3->value.valSTRING) + 1) * sizeof(char));
													strcpy(v->value.valSTRING, $3->value.valSTRING);
												}
												else{
													v->value.valINT = 0;
													memcpy(&v->value, &$3->value, sizeof($3->value)); 
												}

												if(strcmp($3->name, "@const") == 0)
													free($3);
											}
				| ID ASSIGN operations		{
												struct Variable* v = NULL;
												for(int i=0;i<curr_pos;i++)
													if(strcmp(global_variables[i]->name,$1)==0)
														v = global_variables[i];

												if(v == NULL || v->is_const == 1){
													if(strcmp($3->name, "@const") == 0)
														free($3);
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared or is const!!!\n");
													exit(1);
												}

												if(v->type != $3->type){
													if(strcmp($3->name, "@const") == 0)
														free($3);
													printf("Error at line: %d\n", yylineno);
													printf("The types are not compatible!!!\n");
													exit(1);
												}
											
												if(v->type == STRING){
													v->value.valSTRING = (char*)malloc((strlen($3->value.valSTRING) + 1) * sizeof(char));
													strcpy(v->value.valSTRING, $3->value.valSTRING);
												}
												else{
													v->value.valINT = 0;
													memcpy(&v->value, &$3->value, sizeof($3->value)); 
												}

												if(strcmp($3->name, "@const") == 0)
													free($3);
											}
				| ID shortcuts item			
				| ID shortcuts operations
				| ID INCREMENT				{
												struct Variable* v = NULL;
												for(int i=0;i<curr_pos;i++)
													if(strcmp(global_variables[i]->name,$1)==0)
														v = global_variables[i];

												if(v == NULL){
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared!!!\n");
													exit(1);
												}

												if((v->type != INT) && (v->type != CHAR) && (v->type != FLOAT) && (v->is_const == 1)){
													printf("Error at line: %d\n", yylineno);
													printf("Cannot increment this variable!!!\n");
													exit(1);
												}
												
												if(v->type == INT)
													++v->value.valINT;
												else if(v->type == FLOAT)
													++v->value.valFLOAT;
												else if(v->type == CHAR)
													++v->value.valCHAR;

											}
				| ID DECREMENT				{
												struct Variable* v = NULL;
												for(int i=0;i<curr_pos;i++)
													if(strcmp(global_variables[i]->name,$1)==0)
														v = global_variables[i];

												if(v == NULL){
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared!!!\n");
													exit(1);
												}

												if((v->type != INT) && (v->type != CHAR) && (v->type != FLOAT) && (v->is_const == 1)){
													printf("Error at line: %d\n", yylineno);
													printf("Cannot decrement this variable!!!\n");
													exit(1);
												}
												
												if(v->type == INT)
													--v->value.valINT;
												else if(v->type == FLOAT)
													--v->value.valFLOAT;
												else if(v->type == CHAR)
													--v->value.valCHAR;

											}
				;


operations 		: item {$$ = $1;}
				| bool_statement				{
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													strcpy($$->name, "@const");
													$$->type = BOOL;
													$$->value.valBOOL = $1;
												}
				| operations PLUS operations 	{
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													strcpy($$->name, "@const");
													if(($1->type == INT && $3->type == INT) || ($1->type == CHAR && $3->type == INT) || ($1->type == INT && $3->type == CHAR)){
														$$->type = INT;
														$$->value.valINT = (($1->type == INT)? $1->value.valINT : $1->value.valCHAR) + (($3->type == INT)? $3->value.valINT : $3->value.valCHAR);
													}
													else if(($1->type == FLOAT && $3->type == FLOAT) || ($1->type == FLOAT && $3->type == INT) || ($1->type == INT && $3->type == FLOAT)){
														$$->type = FLOAT;
														$$->value.valFLOAT = (($1->type == INT)? $1->value.valINT : $1->value.valFLOAT) + (($3->type == INT)? $3->value.valINT : $3->value.valFLOAT);
													}
													else if($1->type == STRING && $3->type == STRING){
														$$->type = STRING;
														int size = (strlen($1->value.valSTRING) + strlen($3->value.valSTRING) + 1) * sizeof(char);
														$$->value.valSTRING = (char*)malloc(size);
														strcpy($$->value.valSTRING, $1->value.valSTRING);
														strcat($$->value.valSTRING, $3->value.valSTRING);
													}
													else if($1->type == STRING && $3->type == CHAR){
														$$->type = STRING;
														int size = (strlen($1->value.valSTRING) + 2) * sizeof(char);
														$$->value.valSTRING = (char*)malloc(size);
														strcpy($$->value.valSTRING, $1->value.valSTRING);
														$$->value.valSTRING[strlen($$->value.valSTRING) + 1] = '\0';
														$$->value.valSTRING[strlen($$->value.valSTRING)] = $3->value.valCHAR;

													}
													else if($1->type == CHAR && $3->type == STRING){
														$$->type = STRING;
														int size = (strlen($3->value.valSTRING) + 2) * sizeof(char);
														$$->value.valSTRING = (char*)malloc(size);
														$$->value.valSTRING[1] = '\0';
														$$->value.valSTRING[0] = $1->value.valCHAR;
														strcat($$->value.valSTRING, $3->value.valSTRING);
													}
													else{
														compatible = 0;
													}

													if(strcmp($1->name, "@const") == 0)
														free($1);
													if(strcmp($3->name, "@const") == 0)
														free($3);

													if(compatible == 0){
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be added!!!\n");
        												exit(1);
													}

												}
				| operations MINUS operations
												{
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													strcpy($$->name, "@const");
													if(($1->type == INT && $3->type == INT) || ($1->type == CHAR && $3->type == INT) || ($1->type == INT && $3->type == CHAR)){
														$$->type = INT;
														$$->value.valINT = (($1->type == INT)? $1->value.valINT : $1->value.valCHAR) - (($3->type == INT)? $3->value.valINT : $3->value.valCHAR);
													}
													else if(($1->type == FLOAT && $3->type == FLOAT) || ($1->type == FLOAT && $3->type == INT) || ($1->type == INT && $3->type == FLOAT)){
														$$->type = FLOAT;
														$$->value.valFLOAT = (($1->type == INT)? $1->value.valINT : $1->value.valFLOAT) - (($3->type == INT)? $3->value.valINT : $3->value.valFLOAT);
													}
													else{
														compatible = 0;
													}

													if(strcmp($1->name, "@const") == 0)
														free($1);
													if(strcmp($3->name, "@const") == 0)
														free($3);

													if(compatible == 0){
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be added!!!\n");
        												exit(1);
													}
												}
				| operations SLASH operations
												{
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													strcpy($$->name, "@const");
													if(($1->type == INT && $3->type == INT)){
														$$->type = INT;
														$$->value.valINT = ($1->value.valINT / $3->value.valINT);
													}
													else if(($1->type == FLOAT && $3->type == FLOAT) || ($1->type == FLOAT && $3->type == INT) || ($1->type == INT && $3->type == FLOAT)){
														$$->type = FLOAT;
														$$->value.valFLOAT = (($1->type == INT)? $1->value.valINT : $1->value.valFLOAT) / (($3->type == INT)? $3->value.valINT : $3->value.valFLOAT);
													}
													else{
														compatible = 0;
													}

													if(strcmp($1->name, "@const") == 0)
														free($1);
													if(strcmp($3->name, "@const") == 0)
														free($3);

													if(compatible == 0){
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be added!!!\n");
        												exit(1);
													}
												}
				| operations MULT operations	{
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													strcpy($$->name, "@const");
													if(($1->type == INT && $3->type == INT) || ($1->type == CHAR && $3->type == INT) || ($1->type == INT && $3->type == CHAR)){
														$$->type = INT;
														$$->value.valINT = (($1->type == INT)? $1->value.valINT : $1->value.valCHAR) * (($3->type == INT)? $3->value.valINT : $3->value.valCHAR);
													}
													else if(($1->type == FLOAT && $3->type == FLOAT) || ($1->type == FLOAT && $3->type == INT) || ($1->type == INT && $3->type == FLOAT)){
														$$->type = FLOAT;
														$$->value.valFLOAT = (($1->type == INT)? $1->value.valINT : $1->value.valFLOAT) * (($3->type == INT)? $3->value.valINT : $3->value.valFLOAT);
													}
													
													else if($1->type == STRING && $3->type == INT){
														$$->type = STRING;
														int size = ((strlen($1->value.valSTRING) * $3->value.valINT) + 1) * sizeof(char);
														$$->value.valSTRING = (char*)malloc(size);
														strcpy($$->value.valSTRING, $1->value.valSTRING);
														
														for(int i = 1; i < $3->value.valINT; ++i)
															strcat($$->value.valSTRING, $1->value.valSTRING);

													}
													else{
														compatible = 0;
													}

													if(strcmp($1->name, "@const") == 0)
														free($1);
													if(strcmp($3->name, "@const") == 0)
														free($3);

													if(compatible == 0){
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be added!!!\n");
        												exit(1);
													}
												}
				| '(' operations ')'			{ $$ = $2;}
				;

/*Control flow statements*/
bool_statement 	: bool_expresion						{$$ = $1;}
				| bool_statement AND bool_statement		{$$ = $1 && $3;}
				| bool_statement OR bool_statement		{$$ = $1 || $3;}
				| NEG bool_statement					{$$ = !$2;}
				;

bool_expresion	: 
				  item NEQ item 			{
												if($1->type != $3->type){
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if($1->type == STRING)
													$$ = strcmp($1->value.valSTRING, $3->value.valSTRING) != 0;
												else
													$$ = ($1->type == INT) ? $1->value.valINT != $3->value.valINT 
														: ($1->type == FLOAT) ? $1->value.valFLOAT != $3->value.valFLOAT
														: ($1->type == CHAR) ? $1->value.valCHAR != $3->value.valCHAR
														: ($1->type == BOOL) ? $1->value.valBOOL != $3->value.valBOOL : 0;

												if(strcmp($1->name, "@const") == 0)
													free($1);
												if(strcmp($3->name, "@const") == 0)
													free($3);
											}
				| item EQ item				{
												if($1->type != $3->type){
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if($1->type == STRING)
													$$ = strcmp($1->value.valSTRING, $3->value.valSTRING) == 0;
												else
													$$ = ($1->type == INT) ? $1->value.valINT == $3->value.valINT 
														: ($1->type == FLOAT) ? $1->value.valFLOAT == $3->value.valFLOAT
														: ($1->type == CHAR) ? $1->value.valCHAR == $3->value.valCHAR
														: ($1->type == BOOL) ? $1->value.valBOOL == $3->value.valBOOL : 0;

												if(strcmp($1->name, "@const") == 0)
													free($1);
												if(strcmp($3->name, "@const") == 0)
													free($3);
											}

				| item LESS item			{
												if($1->type != $3->type){
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if($1->type == STRING)
													$$ = strcmp($1->value.valSTRING, $3->value.valSTRING) < 0;
												else
													$$ = ($1->type == INT) ? $1->value.valINT < $3->value.valINT 
														: ($1->type == FLOAT) ? $1->value.valFLOAT < $3->value.valFLOAT
														: ($1->type == CHAR) ? $1->value.valCHAR < $3->value.valCHAR
														: ($1->type == BOOL) ? $1->value.valBOOL < $3->value.valBOOL : 0;

												if(strcmp($1->name, "@const") == 0)
													free($1);
												if(strcmp($3->name, "@const") == 0)
													free($3);
											}
				| item LESSOREQ item		{
												if($1->type != $3->type){
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if($1->type == STRING)
													$$ = strcmp($1->value.valSTRING, $3->value.valSTRING) <= 0;
												else
													$$ = ($1->type == INT) ? $1->value.valINT <= $3->value.valINT 
														: ($1->type == FLOAT) ? $1->value.valFLOAT <= $3->value.valFLOAT
														: ($1->type == CHAR) ? $1->value.valCHAR <= $3->value.valCHAR
														: ($1->type == BOOL) ? $1->value.valBOOL <= $3->value.valBOOL : 0;

												if(strcmp($1->name, "@const") == 0)
													free($1);
												if(strcmp($3->name, "@const") == 0)
													free($3);
											}
				| item GREATER item			{
												if($1->type != $3->type){
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if($1->type == STRING)
													$$ = strcmp($1->value.valSTRING, $3->value.valSTRING) > 0;
												else
													$$ = ($1->type == INT) ? $1->value.valINT > $3->value.valINT 
														: ($1->type == FLOAT) ? $1->value.valFLOAT > $3->value.valFLOAT
														: ($1->type == CHAR) ? $1->value.valCHAR > $3->value.valCHAR
														: ($1->type == BOOL) ? $1->value.valBOOL > $3->value.valBOOL : 0;

												if(strcmp($1->name, "@const") == 0)
													free($1);
												if(strcmp($3->name, "@const") == 0)
													free($3);
											}
				| item GREATEROREQ item		{
												if($1->type != $3->type){
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if($1->type == STRING)
													$$ = strcmp($1->value.valSTRING, $3->value.valSTRING) >= 0;
												else
													$$ = ($1->type == INT) ? $1->value.valINT >= $3->value.valINT 
														: ($1->type == FLOAT) ? $1->value.valFLOAT >= $3->value.valFLOAT
														: ($1->type == CHAR) ? $1->value.valCHAR >= $3->value.valCHAR
														: ($1->type == BOOL) ? $1->value.valBOOL >= $3->value.valBOOL : 0;

												if(strcmp($1->name, "@const") == 0)
													free($1);
												if(strcmp($3->name, "@const") == 0)
													free($3);
											}
				| BOOL_CONST				{ $$ = $1;}
				;

item            : ID {
						for(int i=0;i<curr_pos;i++)
							if(strcmp(global_variables[i]->name,$$)==0)
								$$ = global_variables[i];
					}
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