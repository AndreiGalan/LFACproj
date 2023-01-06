%{
#include <stdio.h>
#include "includes.h"
#include "stack.h"
#include <string.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

int array_type = 0;

struct Function* functions[100];
int nr_functions = 0;

struct Class* classes[20];
int nr_classes = 0;

int* params;
char** params_name; 
int nr_params = 0;
int* is_array;

void write_to_file(Variable* var);
void write_function_to_file(Function* func);

int find_class_name(char* name)
{
	for(int i = 0; i < nr_classes; ++i)
		if(strcmp(classes[i]->name, name) == 0)
			return i;

	return -1;
}

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

struct Class* find_class_pointer(char* name)
{
	
	for(int i = 0; i < nr_classes; ++i){
		printf("%s\n",classes[i]->name);
		if(strcmp(classes[i]->name, name) == 0)
			return classes[i];
	}

	return NULL;
}

struct Variable* class_lookup(int class, char* name)
{
	for(int i = 0; i < classes[class]->nr_variables; ++i){
		if(strcmp(classes[class]->variables[i]->name, name) == 0)
		{
			return classes[class]->variables[i];
		}
	}
	
	return NULL;
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
		PROCEDURE FUNCTION ARROW RETURN
		IF ELSE WHILE FOR
		CLASS MEMBER_ACCESS
		NEQ EQ LESS LESSOREQ GREATER GREATEROREQ
		INCREMENT DECREMENT PLUS MINUS MULT SLASH REMAIDER
		AND OR NEG
		ASSIGN 

%token <valINT> INT_CONST
%token <valFLOAT> FLOAT_CONST
%token <valCHAR> CHAR_CONST
%token <valSTRING> STRING_CONST ID TYPEOF
%token <valBOOL> BOOL_CONST

%type <variable> declaration definition constant_value operations item rtn function_call class_access
%type <valINT> TYPE
%type <valBOOL> bool_expresion bool_statement

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
program			: 	{ 
						FILE* fp = fopen("symbol_table_functions.txt", "w");
						fclose(fp);
						fp = fopen("symbol_table.txt", "w");
						fclose(fp);
					} 
					prog_parts MAIN_BLOC 	{
											printf("program corect sintactic\n");
											struct Node* current = GlobalVar;

											for(int i = 0; i < nr_functions; ++i)
												write_function_to_file(functions[i]);

											free_stack_global();
											free_functions();
										}
				;

prog_parts 		: prog_parts function
				| prog_parts declaration ';' 	{
													if(general_lookup($2->name) != NULL){
														add_element(&GlobalVar, $2);
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("The variable is already declared!!!\n");
														exit(1);
													}
													add_element(&GlobalVar, $2);
													write_to_file($2);
												}
				| prog_parts definition ';'		{
													if(general_lookup($2->name) != NULL){
														add_element(&GlobalVar, $2);
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("The variable is already declared!!!\n");
														exit(1);
													}
													add_element(&GlobalVar, $2);
													write_to_file($2);
												}
				| prog_parts class
				|
				;

MAIN_BLOC 		: MAIN {printf("main\n"); stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);} '{' function_block '}'	
     			;

/* CLASS */
class			: CLASS ID 	{
								if(find_class_name($2) != -1){
									free_stack_global();
									free_functions();
									printf("Error at line: %d\n", yylineno);
									printf("The class is already delcared!!!\n");
									exit(1);
								}
								classes[nr_classes] = (struct Class*)malloc(sizeof(struct Class));
								classes[nr_classes]->name = (char*)malloc(sizeof(char*)*(strlen($2)+1));
								strcpy(classes[nr_classes]->name, $2);
								classes[nr_classes]->nr_variables = 0;
								classes[nr_classes]->nr_functions = 0;
							} '{' class_block '}' {++nr_classes;}
				;

class_block		: 
				  class_block function 			{
													--nr_functions;
													for(int i = 0; i < classes[nr_classes]->nr_functions; ++i){
														if(strcmp(classes[nr_classes]->functions[i]->name, functions[nr_functions]->name) == 0){
															free_stack_global();
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("The method is already delcared!!!\n");
															exit(1);
														}
													}
													classes[nr_classes]->functions[classes[nr_classes]->nr_functions++] = functions[nr_functions];
												}
				| class_block declaration ';'	{
													for(int i = 0; i < classes[nr_classes]->nr_variables; ++i){
														if(strcmp(classes[nr_classes]->variables[i]->name, $2->name) == 0){
															free_stack_global();
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("The variable is already delcared!!!\n");
															exit(1);
														}
													}
													classes[nr_classes]->variables[classes[nr_classes]->nr_variables++] = $2;
												}
				| class_block definition ';'	{
													for(int i = 0; i < classes[nr_classes]->nr_variables; ++i){
														if(strcmp(classes[nr_classes]->variables[i]->name, $2->name) == 0){
															free_stack_global();
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("The variable is already delcared!!!\n");
															exit(1);
														}
													}
													classes[nr_classes]->variables[classes[nr_classes]->nr_variables++] = $2;
												}
				| 
				;

class_access 	: 
				  ID MEMBER_ACCESS ID 						{ 
																struct Variable* v = general_lookup($1);
																if(v==NULL)
																{
																	free($1);
																	free($3);
																	free_stack_global();
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The variable is not declared!!!\n");
																	exit(1);
																}
																if(v->type>=INT)
																{
																	free($1);
																	free($3);
																	free_stack_global();
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The variable has no members!!!\n");
																	exit(1);
																}
																$$ = class_lookup(v->type, $3);
																
																free($1);
																free($3);
																if($$ == NULL){
																	free_stack_global();
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The variable is not declared!!!\n");
																	exit(1);
																}
															}
				| ID MEMBER_ACCESS ID '[' item ']' 			{
																struct Variable* v = general_lookup($1);
																if(v==NULL)
																{
																	free($1);
																	free($3);
																	free_stack_global();
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The variable is not declared!!!\n");
																	exit(1);
																}
																if(v->type>=INT)
																{
																	free($1);
																	free($3);
																	free_stack_global();
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The variable is not declared!!!\n");
																	exit(1);
																}
																$$ = class_lookup(v->type, $3);
																
																free($1);
																free($3);
																if($$ == NULL){
																	free_stack_global();
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The variable is not declared!!!\n");
																	exit(1);
																}
																if($5->value.valINT >= $$->size || $5->value.valINT < 0){
																	free_stack_global();
																	free_const($5);
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The index is out of range!!!\n");
																	exit(1);
																}
																free_const($5);
																//printf("%d\n",$$->type);
															}
				| ID MEMBER_ACCESS ID '(' params_call ')'	{
																
															}
				;

/*FUNCTION*/

function		: PROCEDURE ID 
							{	
								if(find_function_name($2) == 0){
									free_stack_global();
									free_functions();
									printf("Error at line: %d\n", yylineno);
									printf("The function is already delcared!!!\n");
									exit(1);
								}
								stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);
								functions[nr_functions] = (struct Function*)malloc(sizeof(struct Function));
								functions[nr_functions]->name = (char*)malloc((strlen($2)+1)*sizeof(char));
								strcpy(functions[nr_functions]->name, $2);
								functions[nr_functions]->nr_parameters = 0;
								functions[nr_functions]->return_type = -1;
							}
							'(' params ')' '{' function_block '}' {++nr_functions; freeStack(stack_scope[curr_pos--]);}
							
				| FUNCTION ID 
							{	
								if(find_function_name($2) == 0){
									free_stack_global();
									free_functions();
									printf("Error at line: %d\n", yylineno);
									printf("The function is already delcared!!!\n");
									exit(1);
								}
								stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);
								functions[nr_functions] = (struct Function*)malloc(sizeof(struct Function));
								functions[nr_functions]->name = (char*)malloc((strlen($2)+1)*sizeof(char));
								strcpy(functions[nr_functions]->name, $2);
								functions[nr_functions]->nr_parameters = 0;
							}
							'(' params ')' ARROW TYPE '{'function_block rtn '}'		
																				{	
																					if($11->type != $8){
																						free_stack_global();
																						free_functions();
																						//free_const($11);
																						printf("Error at line: %d\n", yylineno);
																						printf("The return type is incorect!!!\n");
																						exit(1);
																					}

																					functions[nr_functions]->return_type = $8;
																					++nr_functions;
																					freeStack(stack_scope[curr_pos--]);
																				}
        		;

params 			: 
				  declaration ',' params	
				  							{
												if(general_lookup($1) != NULL){
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is already declared!!!\n");
													exit(1);
												}

												++functions[nr_functions]->nr_parameters; 
												int* temp1 = (int*)malloc(functions[nr_functions]->nr_parameters * sizeof(int));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp1, functions[nr_functions]->parameters, (functions[nr_functions]->nr_parameters -1) * sizeof(int));

												temp1[functions[nr_functions]->nr_parameters - 1] = $1->type;

												free(functions[nr_functions]->parameters);

												functions[nr_functions]->parameters = temp1;


												char** temp2 = (char**)malloc(functions[nr_functions]->nr_parameters * sizeof(char*));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp2, functions[nr_functions]->parameters_name, (functions[nr_functions]->nr_parameters -1) * sizeof(char*));

												temp2[functions[nr_functions]->nr_parameters - 1] = (char*)malloc((strlen($1->name) + 1) * sizeof(char));
												strcpy(temp2[functions[nr_functions]->nr_parameters - 1], $1->name);

												free(functions[nr_functions]->parameters_name);

												functions[nr_functions]->parameters_name = temp2;
												
												int* temp3 = (int*)malloc(functions[nr_functions]->nr_parameters * sizeof(int));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp3, functions[nr_functions]->size, (functions[nr_functions]->nr_parameters -1) * sizeof(int));

												temp3[functions[nr_functions]->nr_parameters - 1] = $1->size;

												free(functions[nr_functions]->size);

												functions[nr_functions]->size = temp3;
		
												add_element(peek(stack_scope[curr_pos]), $1); write_to_file($1);
											}
       			| declaration 				{
												if(general_lookup($1) != NULL){
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is already declared!!!\n");
													exit(1);
												}

												++functions[nr_functions]->nr_parameters; 
												int* temp1 = (int*)malloc(functions[nr_functions]->nr_parameters * sizeof(int));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp1, functions[nr_functions]->parameters, (functions[nr_functions]->nr_parameters -1) * sizeof(int));

												temp1[functions[nr_functions]->nr_parameters - 1] = $1->type;

												free(functions[nr_functions]->parameters);

												functions[nr_functions]->parameters = temp1;


												char** temp2 = (char**)malloc(functions[nr_functions]->nr_parameters * sizeof(char*));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp2, functions[nr_functions]->parameters_name, (functions[nr_functions]->nr_parameters -1) * sizeof(char*));

												temp2[functions[nr_functions]->nr_parameters - 1] = (char*)malloc((strlen($1->name) + 1) * sizeof(char));
												strcpy(temp2[functions[nr_functions]->nr_parameters - 1], $1->name);

												free(functions[nr_functions]->parameters_name);

												functions[nr_functions]->parameters_name = temp2;
												
												int* temp3 = (int*)malloc(functions[nr_functions]->nr_parameters * sizeof(int));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp3, functions[nr_functions]->size, (functions[nr_functions]->nr_parameters -1) * sizeof(int));

												temp3[functions[nr_functions]->nr_parameters - 1] = $1->size;

												free(functions[nr_functions]->size);

												functions[nr_functions]->size = temp3;
		
												add_element(peek(stack_scope[curr_pos]), $1); write_to_file($1);
											}
				|
       			;

function_block 	: function_block assignments 
				| function_block declaration 	{ 
													if(general_lookup($2->name) != NULL){
														add_element(peek(stack_scope[curr_pos]), $2);
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("The variable is already declared!!!\n");
														exit(1);
													}
													add_element(peek(stack_scope[curr_pos]), $2); 
													write_to_file($2); 
												}';'
				| function_block definition 	{ 
													if(general_lookup($2->name) != NULL){
														add_element(peek(stack_scope[curr_pos]), $2);
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("The variable is already declared!!!\n");
														exit(1);
													}
													add_element(peek(stack_scope[curr_pos]), $2); 
													write_to_file($2); 
												}';'
				| function_block function_call ';'
				| function_block class_access ';'
				| function_block while
				| function_block for
				| function_block if
				|
				;

rtn 			: RETURN item ';' {$$ = $2;}
				;

function_call   : 
				  ID 	{
							if(find_function_name($1) == -1){
								free_stack_global();
								free_functions();
								printf("Error at line: %d\n", yylineno);
								printf("The function has not been declared!!!\n");
								exit(1);
							}		
						} 
						'(' params_call ')'	{
												for(int i = 0; i < nr_functions; ++i){
													if(strcmp(functions[i]->name, $1) == 0){
														if(functions[i]->nr_parameters != nr_params){
															free_stack_global();
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("You provided the wrong number of parameters!!!\n");
															exit(1);
														}

														for(int j = 0; j < functions[i]->nr_parameters; ++j){
															if(functions[i]->parameters[j] != params[j]){
																free_stack_global();
																free_functions();
																printf("Error at line: %d\n", yylineno);
																printf("The parameters are of wrong type!!!\n");
																exit(1);
															}
															else
																if(is_array[j]!=0 && functions[i]->size[j]==0 || ((is_array[j]!=0 && functions[i]->size[j]!=0) && functions[i]->size[j]<is_array[j] )){
																	free_stack_global();
																	free_functions();
																	printf("Error at line: %d\n", yylineno);
																	printf("The parameters are of wrong type!!!\n");
																	exit(1);
																}
														}

														$$ = (struct Variable*)malloc(sizeof(struct Variable));
														$$->name = (char*)malloc((strlen("@const")+1)*sizeof(char));
														strcpy($$->name, "@const");
														$$->type = functions[i]->return_type;
														$$->value.valINT = 0;
													}
												}

												free(params);
												free(params_name);
												params = NULL;
												params_name = NULL;
												nr_params = 0;
											}
				;



params_call     : operations ',' params_call 
											{
												int* temp = (int*)malloc(sizeof(int) * (nr_params+1));
												int* temp2 = (int*)malloc(sizeof(int) * (nr_params+1));
												if(nr_params > 0)
												{
													memcpy(temp, params, sizeof(int) * nr_params);
													memcpy(temp2, is_array, sizeof(int) * nr_params);
												}
												printf("%d\n",$1->size);
												temp[nr_params++] = $1->type;
												if($1->size!=0)
													temp2[nr_params-1]=$1->size;
												else
													temp2[nr_params-1]=$1->size;
												free_const($1);

												free(params);
												free(is_array);
												params = temp;
												is_array=temp2;
											}
				| operations 				{
												int* temp = (int*)malloc(sizeof(int) * (nr_params+1));
												int* temp2 = (int*)malloc(sizeof(int) * (nr_params+1));
												if(nr_params > 0)
												{
													memcpy(temp, params, sizeof(int) * nr_params);
													memcpy(temp2, is_array, sizeof(int) * nr_params);
												}
												printf("%d\n",$1->size);
												temp[nr_params++] = $1->type;
												if($1->size!=0)
													temp2[nr_params-1]=$1->size;
												else
													temp2[nr_params-1]=$1->size;
												free_const($1);

												free(params);
												free(is_array);
												params = temp;
												is_array=temp2;
											}
				|
				;

/*DECLARATION DEFINITION*/
declaration 	: 
				  TYPE ID 								{
															$$ = (struct Variable*)malloc(sizeof(struct Variable));
															$$->name = $2;
															$$->type = $1;
															$$->is_const = 0;
															$$->size = 0;
															$$->value.valINT = 0;
														}
				| TYPE ID '[' INT_CONST ']' 			{
															$$ = (struct Variable*)malloc(sizeof(struct Variable));
															$$->name = $2;
															$$->type = $1;
															$$->is_const = 0;
															$$->size = $4;
															$$->value.valINT = 0;
														}
				| ID ID 								{
															int type = 0;

															if((type = find_class_name($1)) == -1){
																free_stack_global();
																free_functions();
																printf("Error at line: %d\n", yylineno);
																printf("Invalid type!!!\n");
																exit(1);
															}

															$$ = (struct Variable*)malloc(sizeof(struct Variable));
															$$->name = $2;
															$$->type = type;
															$$->is_const = 0;
															$$->size = 0;
															$$->value.valINT = 0;
														}
				| ID ID '[' INT_CONST ']'				{
															int type = 0;

															if((type = find_class_name($1)) == -1){
																free_stack_global();
																free_functions();
																printf("Error at line: %d\n", yylineno);
																printf("Invalid type!!!\n");
																exit(1);
															}

															$$ = (struct Variable*)malloc(sizeof(struct Variable));
															$$->name = $2;
															$$->type = type;
															$$->is_const = 0;
															$$->size = $4;
															$$->value.valINT = 0;
														}
				; 

definition  	: 
				  CONST TYPE ID ASSIGN operations 		{
																	
															if($2 != $5->type || $5->size!=0){
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

															$$->size = 0;
															free_const($5);
														}
				| TYPE ID ASSIGN operations				{
															if($1 != $4->type || $4->size!=0){
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
															$$->size = 0;
														}
				| CONST TYPE ID '[' INT_CONST ']' 	{
														array_type = $2;
														printf("aici\n");
													} ASSIGN '{' arr_item'}' 
																				{
																					$$ = (struct Variable*)malloc(sizeof(struct Variable));
																					$$->name = $3;
																					$$->type = $2;
																					$$->is_const = 1;			
																					$$->value.valINT = 0;
																					$$->size = $5;
																					array_type = 0;
																				}
				| TYPE ID '[' INT_CONST ']' 		{
														array_type = $1;
														printf("aici\n");
													} ASSIGN '{' arr_item'}' 
																				{
																					$$ = (struct Variable*)malloc(sizeof(struct Variable));
																					$$->name = $2;
																					$$->type = $1;
																					$$->is_const = 0;			
																					$$->value.valINT = 0;
																					$$->size = $4;
																					array_type = 0;
																				}
				;

arr_item		:
				  operations ',' arr_item 	{
												if($1->type != array_type){
													free_stack_global();
													free_functions();
													free_const($1);
													printf("Error at line: %d\n", yylineno);
													printf("The elements of the array are not as the same type as the array!!!\n");
													exit(1);
												}
											}
				| operations				{
												if($1->type != array_type){
													free_stack_global();
													free_functions();
													free_const($1);
													printf("Error at line: %d\n", yylineno);
													printf("The elements of the array are not as the same type as the array!!!\n");
													exit(1);
												}
											}
				|
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

												if(v->type != $3->type || $3->size!=0 || v->size!=0){
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
				| ID ASSIGN ID '[' item ']'	{
												if($5->type != INT || $5->size != 0){
													free_stack_global();
													free_const($5);
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("Error: Invalid index!!!\n");
													exit(1);
												}

												struct Variable* v = general_lookup($1);
												struct Variable* a = general_lookup($3);

												if(v == NULL || a == NULL || v->is_const == 1){
													free_stack_global();
													free_const($5);
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared or is const!!!\n");
													exit(1);
												}

												if(v->type != a->type || a->size==0 || v->size!=0){
													free_stack_global();
													free_const($5);
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The types are not compatible!!!\n");
													exit(1);
												}
											
												if($5->value.valINT >= a->size || $5->value.valINT < 0){
													free_stack_global();
													free_const($5);
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The index is out of range!!!\n");
													exit(1);
												}

												free_const($5);
											}
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
				| ID '[' item ']' ASSIGN operations 
											{
												if($3->type != INT || $3->size != 0){
													free_const($6);
													free_const($3);
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("Error: Invalid index!!!\n");
													exit(1);
												}

												struct Variable* v = general_lookup($1);
												if(v == NULL || v->is_const == 1){
													free_const($6);
													free_const($3);
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared or is const!!!\n");
													exit(1);
												}

												if(v->type != $6->type || $6->size!=0){
													free_const($6);
													free_const($3);
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The types are not compatible!!!\n");
													exit(1);
												}

												if($3->value.valINT >= v->size || $3->value.valINT < 0){
													free_const($6);
													free_const($3);
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The index is out of range!!!\n");
													exit(1);
												}


											}
				| ID '[' item ']' ASSIGN ID '[' item ']'
											{
												if($3->type != INT || $3->size != 0 || $8->type != INT || $8->size != 0){
													free_stack_global();
													free_functions();
													free_const($3);
													free_const($8);
													printf("Error at line: %d\n", yylineno);
													printf("Error: Invalid index!!!\n");
													exit(1);
												}

												struct Variable* a1 = general_lookup($1);
												struct Variable* a2 = general_lookup($6);

												if(a1 == NULL || a2 == NULL || a1->is_const == 1){
													free_stack_global();
													free_functions();
													free_const($3);
													free_const($8);
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared or is const!!!\n");
													exit(1);
												}

												if(a1->type != a2->type){
													free_stack_global();
													free_const($3);
													free_const($8);
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The types are not compatible!!!\n");
													exit(1);
												}
											
												if($3->value.valINT >= a1->size || $3->value.valINT < 0 || $8->value.valINT >= a2->size || $8->value.valINT < 0){
													free_stack_global();
													free_const($3);
													free_const($8);
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The index is out of range!!!\n");
													exit(1);
												}

												free_const($3);
												free_const($8);
											}
				| class_access ASSIGN operations
												{
													
													if($1->type != $3->type || $3->size!=0){
														free_const($3);
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("The types are not compatible!!!\n");
														exit(1);
													}
												
													if($1->type == STRING){
														$1->value.valSTRING = (char*)malloc((strlen($3->value.valSTRING) + 1) * sizeof(char));
														strcpy($1->value.valSTRING, $3->value.valSTRING);
													}
													else{
														$1->value.valINT = 0;
														memcpy(&$1->value, &$3->value, sizeof($3->value)); 
													}

													free_const($3);
													}
		        | class_access ASSIGN ID '[' item ']'{
														if($5->type != INT || $5->size != 0){
															free_stack_global();
															free_const($5);
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("Error: Invalid index!!!\n");
															exit(1);
														}
														struct Variable* a = general_lookup($3);

														if(a == NULL){
															free_stack_global();
															free_const($5);
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("The variable is not declared or is const!!!\n");
															exit(1);
														}

														if($1->type != a->type || a->size==0 ){
															free_stack_global();
															free_const($5);
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("The types are not compatible!!!\n");
															exit(1);
														}
													
														if($5->value.valINT >= a->size || $5->value.valINT < 0){
															free_stack_global();
															free_const($5);
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("The index is out of range!!!\n");
															exit(1);
														}

														free_const($5);
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
													if($1->size!=0 || $3->size!=0)
														compatible=0;
													else
													{
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
														else{
															compatible = 0;
														}
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
				| function_call					{
													if($1->type == -1){
														free_stack_global();
														free_functions();
														free_const($1);
														printf("Error at line: %d\n", yylineno);
														printf("Procedures don't return any value!!!\n");
														exit(1);
													}

													$$ = $1;
												}
				| class_access
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

for				: FOR '(' definition ';' bool_statement ';' assignment ')' {push(stack_scope[curr_pos]);} '{' function_block '}'{ 	
																																	struct Node* n = pop(stack_scope[curr_pos]);
																																	delete_list(&n);
																																}
				| FOR '(' assignment ';' bool_statement ';' assignment ')' {push(stack_scope[curr_pos]);} '{' function_block '}'{ 	
																																	struct Node* n = pop(stack_scope[curr_pos]);
																																	delete_list(&n);
																																}
				;

if 				: IF '(' bool_statement ')' {push(stack_scope[curr_pos]);} '{' function_block '}' 	{ 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									}
				| IF '(' bool_statement ')' {push(stack_scope[curr_pos]);} '{' function_block '}' 	{ 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									} 
																									ELSE {push(stack_scope[curr_pos]);} '{' function_block '}'	
																									{ 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									}
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

void write_to_file(Variable* var)
{
    FILE* fp = fopen("symbol_table.txt", "a");
    if (fp == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }

	if(var->size == 0){	
		fprintf(fp, "Variable name: %s,", var->name);
		switch (var->type)
		{
			case INT:
				fprintf(fp, "Type: int, Value: %d;", var->value.valINT);
				break;
			case FLOAT:
				fprintf(fp, "Type: float, Value: %f;", var->value.valFLOAT);
				break;
			case CHAR:
				fprintf(fp, "Type: char, Value: %c;", var->value.valCHAR);
				break;
			case STRING:
				fprintf(fp, "Type: string, Value: %s;", var->value.valSTRING);
				break;
			case BOOL:
				fprintf(fp, "Type: bool, Value: %d;", var->value.valBOOL);
				break;
			default:
				fprintf(fp, "Type: User defined;");
				break;
		}
	}
	else{
		fprintf(fp, "Array name: %s,", var->name);
		switch (var->type)
		{
			case INT:
				fprintf(fp, "Type: int;");
				break;
			case FLOAT:
				fprintf(fp, "Type: float;");
				break;
			case CHAR:
				fprintf(fp, "Type: char;");
				break;
			case STRING:
				fprintf(fp, "Type: string;");
				break;
			case BOOL:
				fprintf(fp, "Type: bool;");
				break;
			default:
				fprintf(fp, "Type: User defined;");
				break;
		}
	}

	fprintf(fp, "\n");

    fclose(fp);
}

void write_function_to_file(Function* func)
{
    FILE* fp = fopen("symbol_table_functions.txt", "a");
    if (fp == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }

    fprintf(fp, "Function name: %s, ", func->name);
	switch (func->return_type)
    {
        case INT:
            fprintf(fp, "Return type: int, ");
            break;
        case FLOAT:
            fprintf(fp, "Return type: float, ");
            break;
        case CHAR:
            fprintf(fp, "Return type: char, ");
            break;
        case STRING:
            fprintf(fp, "Return type: string, ");
            break;
        case BOOL:
            fprintf(fp, "Return type: bool, ");
            break;
        default:
            fprintf(fp, "Return type: User defined, ");
			break;
    }

	fprintf(fp, "Parameters: ");

    for (int i = func->nr_parameters-1; i >= 0; i--)
    {
		//printf("%s\n", func->parameters_name[i]);
		fprintf(fp, "Parameter name: %s, ", func->parameters_name[i]);
        switch (func->parameters[i])
		{
			case INT:
				fprintf(fp, "Parameter type: int. ");
				break;
			case FLOAT:
				fprintf(fp, "Parameter type: float. ");
				break;
			case CHAR:
				fprintf(fp, "Parameter type: char. ");
				break;
			case STRING:
				fprintf(fp, "Parameter type: string. ");
				break;
			case BOOL:
				fprintf(fp, "Parameter type: bool. ");
				break;
			default:
				fprintf(fp, "Parameter type: User defined.");
				break;
		}
    }
    fprintf(fp, "\n");

    fclose(fp);
}

int yyerror(char * s){
	printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
	yyin=fopen(argv[1],"r");
	yyparse();
} 