%{
#include <stdio.h>
#include "includes.h"
#include "stack.h"
#include <string.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;


struct Function* functions[100];
int nr_functions = 0;

int* params;
int nr_params = 0;


int find_function_name(char* name)
{
	for(int i = 0; i < nr_functions; ++i)
		if(strcmp(functions[i]->name, name) == 0)
			return 0;

	return -1;
}

void free_functions()
{
	for(int i = 0; i < nr_functions; ++i){
		free(functions[i]->name);
		free(functions[i]->parameters);
		free(functions[i]);
	}
}


struct Stack* stack_scope[100];
int curr_pos = -1;

struct Node* GlobalVar = NULL;

void free_const(struct Variable* v);

void free_stack_global()
{
	delete_list(&GlobalVar);
	for(int i = 0; i < curr_pos; ++i)
		freeStack(stack_scope[i]);
}

struct Variable* general_lookup(const char* name)
{
	struct Variable* var = lookup_element(GlobalVar, name);

	if(curr_pos >= 0 ){
		for(int i = 0; i <= stack_scope[curr_pos]->top; ++i){
			if(var != NULL)
				return var;
			var = lookup_element(stack_scope[curr_pos]->data[i], name);
		}
	}
	return var;
}

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
%token <valSTRING> STRING_CONST ID TYPEOF
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
											struct Node* current = GlobalVar;
											while (current != NULL) {
												printf("%s, %d\n", current->variable->name, current->variable->value.valINT);
												current = current->next;
											}
											printf("\n");

											current = *peek(stack_scope[curr_pos]);
											while (current != NULL) {
												printf("%s, %d\n", current->variable->name, current->variable->value.valINT);
												current = current->next;
											}
											printf("\n");

											free_stack_global();
											free_functions();
										}
				;

prog_parts 		: prog_parts function
				| prog_parts declaration ';' 	{
													add_element(&GlobalVar, $2);
												}
				| prog_parts definition ';'		{
													add_element(&GlobalVar, $2);
												}
				| prog_parts class
				|
				;

MAIN_BLOC 		: MAIN {printf("main\n"); stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);} '{' function_block '}'	
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

function		: FUNCTION ID 
							{	
								if(find_function_name($2) == 0){
									free_stack_global();
									free_functions();
									printf("Error at line: %d\n", yylineno);
									printf("The function is already delcared!!!\n");
									exit(1);
								}
								functions[nr_functions] = (struct Function*)malloc(sizeof(struct Function));
								functions[nr_functions]->name = (char*)malloc((strlen($2)+1)*sizeof(char));
								strcpy(functions[nr_functions]->name, $2);
								functions[nr_functions]->nr_parameters = 0;
							}
							'(' params ')' ARROW TYPE '{' function_block rtn '}'	{	
																						functions[nr_functions]->return_type = $8;
																						++nr_functions;
																					}
        		| FUNCTION ID 
							{	
								if(find_function_name($2) == 0){
									free_stack_global();
									free_functions();
									printf("Error at line: %d\n", yylineno);
									printf("The function is already delcared!!!\n");
									exit(1);
								}
								functions[nr_functions] = (struct Function*)malloc(sizeof(struct Function));
								functions[nr_functions]->name = (char*)malloc((strlen($2)+1)*sizeof(char));
								strcpy(functions[nr_functions]->name, $2);
								functions[nr_functions]->nr_parameters = 0;
								functions[nr_functions]->return_type = -1;
							}
							'(' params ')' '{' function_block '}' {++nr_functions;}
        		;

params 			: 
				  declaration ',' params	{
												++functions[nr_functions]->nr_parameters; 
												int* temp = (int*)malloc(functions[nr_functions]->nr_parameters * sizeof(int));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp, functions[nr_functions]->parameters, (functions[nr_functions]->nr_parameters -1) * sizeof(int));

												temp[functions[nr_functions]->nr_parameters - 1] = $1->type;
												free_const($1);

												free(functions[nr_functions]->parameters);

												functions[nr_functions]->parameters = temp;
											}
       			| declaration 				{
												++functions[nr_functions]->nr_parameters; 
												int* temp = (int*)malloc(functions[nr_functions]->nr_parameters * sizeof(int));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp, functions[nr_functions]->parameters, (functions[nr_functions]->nr_parameters -1) * sizeof(int));

												temp[functions[nr_functions]->nr_parameters - 1] = $1->type;
												free_const($1);

												free(functions[nr_functions]->parameters);

												functions[nr_functions]->parameters = temp;
											}
				|
       			;

function_block 	: function_block assignments 
				| function_block declaration { add_element(peek(stack_scope[curr_pos]), $2); }';'
				| function_block definition { add_element(peek(stack_scope[curr_pos]), $2); }';'
				| function_block function_call ';'
				| function_block while
				| function_block for
				| function_block if
				|
				;

rtn 			: RETURN ID ';'
				| RETURN item ';'
				;
function_call   : FUNCTION ID 	{
									if(find_function_name($2) == -1){
										free_stack_global();
										free_functions();
										printf("Error at line: %d\n", yylineno);
										printf("The function has not been declared!!!\n");
										exit(1);
									}

									
								} 
								'(' params_call ')'	{
														for(int i = 0; i < nr_functions; ++i){
															if(strcmp(functions[i]->name, $2) == 0){
																if(functions[i]->nr_parameters != nr_params){
																	free_stack_global();
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The function has not been declared!!!\n");
																	exit(1);
																}

																for(int j = 0; j < functions[i]->nr_parameters; ++j){
																	if(functions[i]->parameters[j] != params[j]){
																		free_stack_global();
																		free_functions();
																		printf("Error at line: %d\n", yylineno);
																		printf("The function has not been declared!!!\n");
																		exit(1);
																	}
																}
															}
														}

														free(params);
														nr_params = 0;
													}
				;



params_call     : operations ',' params_call 
											{
												int* temp = (int*)malloc(sizeof(int) * (nr_params+1));
												if(nr_params > 0)
													memcpy(temp, params, sizeof(int) * nr_params);

												temp[nr_params++] = $1->type;
												free_const($1);

												free(params);
												params = temp;
											}
				| operations 				{
												int* temp = (int*)malloc(sizeof(int) * (nr_params+1));
												if(nr_params > 0)
													memcpy(temp, params, sizeof(int) * nr_params);

												temp[nr_params++] = $1->type;
												free_const($1);

												free(params);
												params = temp;
											}
				|
				;

/*DECLARATION DEFINITION*/
declaration 	: 
				  TYPE ID 								{
															if(general_lookup($2) != NULL){
																free_stack_global();
																free_functions();
																printf("Error at line: %d\n", yylineno);
																printf("The variable is already declared!!!\n");
																exit(1);
															}
															$$ = (struct Variable*)malloc(sizeof(struct Variable));
															$$->name = $2;
															$$->type = $1;
															$$->is_const = 0;
															$$->value.valINT = 0;
														}
				| TYPE ID '[' INT_CONST ']' 
				; 

definition  	: 
				  CONST TYPE ID ASSIGN operations 		{
															if(general_lookup($3) != NULL){
																free_stack_global();
																free_functions();
																free_const($5);
																printf("Error at line: %d\n", yylineno);
																printf("The variable is already declared!!!\n");
																exit(1);
															}
																	
															if($2 != $5->type){
																free_stack_global();
																free_functions();
																free_const($5);
																printf("Error at line: %d\n", yylineno);
																printf("The types are incompatible!!!\n");
        														exit(1);
															}

															if(strcmp($5->name, "@const") == 0){
																$$ = $5;
																$$->name = $3;
																$$->is_const = 1;
															}
															else{
																$$ = (struct Variable*)malloc(sizeof(struct Variable));
																$$->name = $3;
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
															
															free_const($5);
														}
				| TYPE ID ASSIGN operations				{
															if(general_lookup($2) != NULL){
																free_stack_global();
																free_functions();
																free_const($4);
																printf("Error at line: %d\n", yylineno);
																printf("The variable is already declared!!!\n");
																exit(1);
															}
															if($1 != $4->type){
																free_stack_global();
																free_functions();
																free_const($4);
																printf("eroare la linia:%d\n", yylineno);
																printf("The types are incompatible!!!\n");
        														exit(1);
															}

															if(strcmp($4->name, "@const") == 0){
																$$ = $4;
																$$->name = $2;
																$$->is_const = 0;
															}
															else{
																$$ = (struct Variable*)malloc(sizeof(struct Variable));
																$$->name = $2;
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
															
															free_const($4);
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
									$$->name = (char*)malloc(strlen("@const") + 1);
									strcpy($$->name, "@const");
									$$->type = INT;
									$$->value.valINT = $1;
								}
				| FLOAT_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									$$->name = (char*)malloc(strlen("@const") + 1);
									strcpy($$->name, "@const");
									$$->type = FLOAT;
									$$->value.valFLOAT = $1;
								}
				| STRING_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									$$->name = (char*)malloc(strlen("@const") + 1);
									strcpy($$->name, "@const");
									$$->type = STRING;
									$$->value.valSTRING = (char*)malloc((strlen($1) - 1) * sizeof(char));
									$1[strlen($1) - 1] = '\0';
									strcpy($$->value.valSTRING, $1 + 1);
								}
				| CHAR_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									$$->name = (char*)malloc(strlen("@const") + 1);
									strcpy($$->name, "@const");
									$$->type = CHAR;
									$$->value.valCHAR = $1;
								}
				| BOOL_CONST 	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									$$->name = (char*)malloc(strlen("@const") + 1);
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
				  ID ASSIGN operations		{
												struct Variable* v = general_lookup($1);

												if(v == NULL || v->is_const == 1){
													free_const($3);
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared or is const!!!\n");
													exit(1);
												}

												if(v->type != $3->type){
													free_const($3);
													free_stack_global();
													free_functions();
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

												free_const($3);
											}	
				| ID shortcuts operations
				| ID INCREMENT				{
												struct Variable* v = general_lookup($1);

												if(v == NULL){
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared!!!\n");
													exit(1);
												}

												if((v->type != INT) && (v->type != CHAR) && (v->type != FLOAT) && (v->is_const == 1)){
													free_stack_global();
													free_functions();
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
												struct Variable* v = general_lookup($1);

												if(v == NULL){
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared!!!\n");
													exit(1);
												}

												if((v->type != INT) && (v->type != CHAR) && (v->type != FLOAT) && (v->is_const == 1)){
													free_stack_global();
													free_functions();
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


operations 		: item 							{$$ = $1;}
				| bool_statement				{
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													$$->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->name, "@const");
													$$->type = BOOL;
													$$->value.valBOOL = $1;
												}
				| operations PLUS operations 	{
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													$$->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->name, "@const");
													if($1->type == INT && $3->type == INT){
														$$->type = INT;
														$$->value.valINT = $1->value.valINT + $3->value.valINT;
													}
													else if($1->type == FLOAT && $3->type == FLOAT){
														$$->type = FLOAT;
														$$->value.valFLOAT = $1->value.valFLOAT + $3->value.valFLOAT;
													}
													else if($1->type == STRING && $3->type == STRING){
														$$->type = STRING;
														int size = (strlen($1->value.valSTRING) + strlen($3->value.valSTRING) + 1) * sizeof(char);
														$$->value.valSTRING = (char*)malloc(size);
														strcpy($$->value.valSTRING, $1->value.valSTRING);
														strcat($$->value.valSTRING, $3->value.valSTRING);
													}
													// else if($1->type == STRING && $3->type == CHAR){
													// 	$$->type = STRING;
													// 	int size = (strlen($1->value.valSTRING) + 2) * sizeof(char);
													// 	$$->value.valSTRING = (char*)malloc(size);
													// 	strcpy($$->value.valSTRING, $1->value.valSTRING);
													// 	$$->value.valSTRING[strlen($$->value.valSTRING) + 1] = '\0';
													// 	$$->value.valSTRING[strlen($$->value.valSTRING)] = $3->value.valCHAR;

													// }
													// else if($1->type == CHAR && $3->type == STRING){
													// 	$$->type = STRING;
													// 	int size = (strlen($3->value.valSTRING) + 2) * sizeof(char);
													// 	$$->value.valSTRING = (char*)malloc(size);
													// 	$$->value.valSTRING[1] = '\0';
													// 	$$->value.valSTRING[0] = $1->value.valCHAR;
													// 	strcat($$->value.valSTRING, $3->value.valSTRING);
													// }
													else{
														compatible = 0;
													}

													free_const($1);
													free_const($3);

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be added!!!\n");
        												exit(1);
													}

												}
				| operations MINUS operations	{
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													$$->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->name, "@const");
													if($1->type == INT && $3->type == INT){
														$$->type = INT;
														$$->value.valINT = $1->value.valINT - $3->value.valINT;
													}
													else if($1->type == FLOAT && $3->type == FLOAT){
														$$->type = FLOAT;
														$$->value.valFLOAT = $1->value.valFLOAT - $3->value.valFLOAT;
													}
													else{
														compatible = 0;
													}

													free_const($1);
													free_const($3);

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be subtracted!!!\n");
        												exit(1);
													}
												}
				| operations SLASH operations	{
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													$$->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->name, "@const");
													if(($1->type == INT && $3->type == INT)){
														$$->type = INT;
														$$->value.valINT = ($1->value.valINT / $3->value.valINT);
													}
													else if($1->type == FLOAT && $3->type == FLOAT){
														$$->type = FLOAT;
														$$->value.valFLOAT = $1->value.valFLOAT / $3->value.valFLOAT;
													}
													else{
														compatible = 0;
													}

													free_const($1);
													free_const($3);

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be divided!!!\n");
        												exit(1);
													}
												}
				| operations MULT operations	{
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													$$->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->name, "@const");
													if($1->type == INT && $3->type == INT){
														$$->type = INT;
														$$->value.valINT = $1->value.valINT * $3->value.valINT;
													}
													else if($1->type == FLOAT && $3->type == FLOAT){
														$$->type = FLOAT;
														$$->value.valFLOAT = $1->value.valFLOAT * $3->value.valFLOAT;
													}
													// else if($1->type == STRING && $3->type == INT){
													// 	$$->type = STRING;
													// 	int size = ((strlen($1->value.valSTRING) * $3->value.valINT) + 1) * sizeof(char);
													// 	$$->value.valSTRING = (char*)malloc(size);
													// 	strcpy($$->value.valSTRING, $1->value.valSTRING);
														
													// 	for(int i = 1; i < $3->value.valINT; ++i)
													// 		strcat($$->value.valSTRING, $1->value.valSTRING);
													// }
													else{
														compatible = 0;
													}

													free_const($1);
													free_const($3);

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be multiplyed!!!\n");
        												exit(1);
													}
												}
				| operations REMAIDER operations {
													int compatible = 1;
													$$ = (struct Variable*)malloc(sizeof(struct Variable));
													$$->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->name, "@const");
													if(($1->type == INT && $3->type == INT)){
														$$->type = INT;
														$$->value.valINT = $1->value.valINT % $3->value.valINT;
													}
													else{
														compatible = 0;
													}

													free_const($1);
													free_const($3);

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be divided!!!\n");
        												exit(1);
													}
												}
				| '(' operations ')'			{ $$ = $2;}
				| function_call
				;

/*Control flow statements*/
bool_statement 	: bool_expresion						{$$ = $1;}
				| '(' bool_statement ')'				{$$ = $2;}
				| bool_statement AND bool_statement		{$$ = $1 && $3;}
				| bool_statement OR bool_statement		{$$ = $1 || $3;}
				| NEG bool_statement					{$$ = !$2;}
				;

bool_expresion	: 
				  item						{
												if($1->type != BOOL){
													free_stack_global();
													free_functions();
													free_const($1);
													printf("Error at line: %d\n", yylineno);
													printf("Thise variables is not of type bool!!!\n");
													exit(1);
												}

												$$ = $1->value.valBOOL;
												free_const($1);
											}
				| item NEQ item 			{
												if($1->type != $3->type){
													free_stack_global();
													free_functions();
													free_const($1);
													free_const($3);
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

												free_const($1);
												free_const($3);
											}
				| item EQ item				{
												if($1->type != $3->type){
													free_stack_global();
													free_functions();
													free_const($1);
													free_const($3);
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

												free_const($1);
												free_const($3);
											}

				| item LESS item			{
												if($1->type != $3->type){
													
													free_stack_global();
													free_functions();
													free_const($1);
													free_const($3);
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

												free_const($1);
												free_const($3);
											}
				| item LESSOREQ item		{
												if($1->type != $3->type){
													free_stack_global();
													free_functions();
													free_const($1);
													free_const($3);
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

												free_const($1);
												free_const($3);
											}
				| item GREATER item			{
												if($1->type != $3->type){
													free_stack_global();
													free_functions();
													free_const($1);
													free_const($3);
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

												free_const($1);
												free_const($3);
											}
				| item GREATEROREQ item		{
												if($1->type != $3->type){
													free_stack_global();
													free_functions();
													free_const($1);
													free_const($3);
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

												free_const($1);
												free_const($3);
											}
				;

item            : 
				ID {
						$$ = general_lookup($1);
						free($1);
						if($$ == NULL){
							free_stack_global();
							free_functions();
							printf("Error at line: %d\n", yylineno);
							printf("The variable is not declared!!!\n");
							exit(1);
						}
					}
				| constant_value
				;
				

while  			: WHILE '(' bool_statement ')' {push(stack_scope[curr_pos]);} '{' function_block '}' { 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									 }
				;

for				: FOR '(' definition ';' bool_statement ';' assignment ')' '{' function_block '}'
				| FOR '(' assignment ';' bool_statement ';' assignment ')' '{' function_block '}'
				;

if 				: IF '(' bool_statement ')' '{' function_block '}'
				| IF '(' bool_statement ')' '{' function_block '}' ELSE '{' function_block '}'
				;
%%

void free_const(struct Variable* v){
	if(strcmp(v->name, "@const") == 0){
		if(v->type == STRING)
			free(v->value.valSTRING);
		free(v->name);
		free(v);
	}
}

void delete_list(struct Node **head)
{
	struct Node *current = *head;
	while (current != NULL)
	{
		struct Node *temp = current;
		current = current->next;
		if(temp->variable->type == STRING)
			free(temp->variable->value.valSTRING);
		free(temp->variable->name);
		free(temp->variable);
		free(temp);
	}
	*head = NULL;
}

int yyerror(char * s){
	printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
	yyin=fopen(argv[1],"r");
	yyparse();
} 