%{
#include <stdio.h>
#include "includes.h"
#include "stack.h"
#include <string.h>
#include "ast_tree.c"
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

struct Class* current_class = NULL;

int array_type = 0;

struct Function* functions[100];
int nr_functions = 0;

struct Class* classes[20];
int nr_classes = 0;

int* params;
char** params_name; 
int nr_params = 0;
int* is_array;
int nr_items=0;
int in_main=0;

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
	{
		if(strcmp(functions[i]->name, name) == 0)
			return 0;
	}
	return -1;
}

int find_function_name2(char* name)
{
	for(int i = 0; i <= nr_functions; ++i)
	{
		if(strcmp(functions[i]->name, name) == 0)
			return 0;
	}
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

void free_classes();

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
	for(int i = 0; i < classes[class]->nr_variables; ++i)
		if(strcmp(classes[class]->variables[i]->name, name) == 0)
			return classes[class]->variables[i];
	
	return NULL;
}

struct Function* class_fun_lookup(int class, char* name)
{
	for(int i = 0; i < classes[class]->nr_functions; ++i)
		if(strcmp(classes[class]->functions[i]->name, name) == 0)
			return classes[class]->functions[i];

	return NULL;
}


void error_message(const char* errorMessage)
{
	free_stack_global();
	free_functions();
	free_classes();

	fprintf(stderr, "\033[0;31mError at line: %d; ", yylineno);
    fprintf(stderr, "%s\033[0m", errorMessage);
	exit(1);
}


struct AST_VAR{
	struct Variable* variable;
	struct AstNode* ast;
};

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
  struct AST_VAR* ast_var;
}


%token 	MAIN CONST EVAL TYPEOF
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
%token <valSTRING> STRING_CONST ID
%token <valBOOL> BOOL_CONST

%type <variable> declaration definition constant_value rtn function_call class_access_var class_access_fun
%type <valINT> TYPE
%type <valBOOL> bool_expresion bool_statement
%type <ast_var> item operations

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
					prog_parts	{
									nr_functions--;
								} 
					MAIN_BLOC 	{
											printf("program corect sintactic\n");
											struct Node* current = GlobalVar;

											for(int i = 0; i < nr_functions; ++i)
												write_function_to_file(functions[i]);

											free_stack_global();
											free_functions();
											free_classes();		
										}
				;

prog_parts 		: prog_parts function
				| prog_parts declaration ';' 	{
													if(general_lookup($2->name) != NULL){
														add_element(&GlobalVar, $2);
														error_message("The variable is already declared!!!");
													}
													add_element(&GlobalVar, $2);
													write_to_file($2);
												}
				| prog_parts definition ';'		{
													if(general_lookup($2->name) != NULL){
														add_element(&GlobalVar, $2);
														error_message("The variable is already declared!!!");
													}
													add_element(&GlobalVar, $2);
													write_to_file($2);
												}
				| prog_parts class
				|
				;

MAIN_BLOC 		: MAIN {stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);} '{' function_block '}'	
     			;

/* CLASS */
class			: CLASS ID 	{
								if(find_class_name($2) != -1){
									error_message("The class is already delcared!!!\n");
								}
								classes[nr_classes] = (struct Class*)malloc(sizeof(struct Class));
								classes[nr_classes]->name = (char*)malloc(sizeof(char*)*(strlen($2)+1));
								strcpy(classes[nr_classes]->name, $2);
								classes[nr_classes]->nr_variables = 0;
								classes[nr_classes]->nr_functions = 0;
								current_class = classes[nr_classes];
							} '{' class_block '}' {++nr_classes; current_class = NULL;}
				;

class_block		: 
				  class_block function 			{
													--nr_functions;
													for(int i = 0; i < classes[nr_classes]->nr_functions; ++i){
														if(strcmp(classes[nr_classes]->functions[i]->name, functions[nr_functions]->name) == 0){
															error_message("The method is already delcared!!!\n");
														}
													}
													classes[nr_classes]->functions[classes[nr_classes]->nr_functions++] = functions[nr_functions];
												}
				| class_block declaration ';'	{
													for(int i = 0; i < classes[nr_classes]->nr_variables; ++i){
														if(strcmp(classes[nr_classes]->variables[i]->name, $2->name) == 0){
															error_message("The variable is already delcared!!!\n");
														}
													}
													classes[nr_classes]->variables[classes[nr_classes]->nr_variables++] = $2;
												}
				| class_block definition ';'	{
													for(int i = 0; i < classes[nr_classes]->nr_variables; ++i){
														if(strcmp(classes[nr_classes]->variables[i]->name, $2->name) == 0){
															error_message("The variable is already delcared!!!\n");
														}
													}
													classes[nr_classes]->variables[classes[nr_classes]->nr_variables++] = $2;
												}
				| 
				;

class_access_var: 
				  ID  MEMBER_ACCESS ID 						{ 
																struct Variable* v = general_lookup($1);
																if(v==NULL){
																	free($1);
																	free($3);
																	error_message("The variable is not declared!!!\n");
																}

																$$ = class_lookup(v->type, $3);
																free($1);
																free($3);

																if(v->type>=INT){
																	error_message("The variable has no members!!!\n");
																}
																if(v->size!=0){
																	error_message("The variable must be an array!!!\n");
																}
																if($$ == NULL){
																	error_message("The variable is not declared!!!\n");
																}
															}
				| ID MEMBER_ACCESS ID '[' item ']' 			{
																free_AST($5->ast);
																struct Variable* v = general_lookup($1);
																free($1);

																if(v==NULL){
																	free($3);
																	error_message("The variable is not declared!!!\n");
																}

																struct Variable* a = class_lookup(v->type, $3);
																free($3);

																if(v->type>=INT){
																	error_message("The variable is not declared!!!\n");
																}
																if(v->size!=0){
																	error_message("The variable must be an array!!!\n");
																}

																if(a == NULL){
																	error_message("The variable is not declared!!!\n");
																}
																if($5->variable->value.valINT >= a->size || $5->variable->value.valINT < 0){
																	free_const($5->variable);
																	error_message("The index is out of range!!!\n");
																}

																$$ = (struct Variable*)malloc(sizeof(struct Variable));
																$$->name = (char*)malloc(sizeof(char)*(strlen("@const") + 1));
																strcpy($$->name,"@const");
																$$->type = a->type;
																$$->size = 0;
																$$->value.valINT = 0;

																free_const($5->variable);
															}
				| ID '[' item ']'  MEMBER_ACCESS ID 		{ 
																free_AST($3->ast);
																struct Variable* v = general_lookup($1);
																free($1);
																if(v==NULL){
																	free($6);
																	free_const($3->variable);
																	error_message("The variable is not declared!!!\n");
																}

																$$ = class_lookup(v->type, $6);
																free($6);

																if(v->type>=INT){
																	free_const($3->variable);
																	error_message("The variable has no members!!!\n");
																}
																if(v->size==0){
																	free_const($3->variable);
																	error_message("The variable is not an array!!!\n");
																}
																if($3->variable->type != INT || $3->variable->size != 0){
																	free_const($3->variable);
																	error_message("Error: Invalid index!!!\n");
																}
																if($3->variable->value.valINT >= v->size || $3->variable->value.valINT < 0){
																	free_const($3->variable);
																	error_message("The index is out of range!!!\n");
																}
																
																free_const($3->variable);
																if($$ == NULL){
																	error_message("The variable is not declared!!!\n");
																}
															}
				| ID '[' item ']' MEMBER_ACCESS ID '[' item ']' 			{
																free_AST($3->ast);
																free_AST($8->ast);
																struct Variable* v = general_lookup($1);
																free($1);
																if(v==NULL){
																	free($6);
																	free_const($3->variable);
																	free_const($8->variable);
																	error_message("The variable is not declared!!!\n");
																}
																struct Variable* a = class_lookup(v->type, $6);
																free($6);

																if(v->type>=INT){
																	free_const($3->variable);
																	free_const($8->variable);
																	error_message("The variable is not declared!!!\n");
																}
																if(v->size==0){
																	free_const($3->variable);
																	free_const($8->variable);
																	error_message("The variable is not an array!!!\n");
																}
																if($3->variable->type != INT || $3->variable->size != 0){
																	free_const($3->variable);
																	free_const($8->variable);
																	error_message("Error: Invalid index!!!\n");
																}
																if($3->variable->value.valINT >= v->size || $3->variable->value.valINT < 0){
																	free_const($3->variable);
																	free_const($8->variable);
																	error_message("The index is out of range!!!\n");
																}
																free_const($3->variable);
																

																if(a == NULL){
																	free_const($8->variable);
																	error_message("The variable is not declared!!!\n");
																}
																if($8->variable->value.valINT >= a->size || $8->variable->value.valINT < 0){
																	free_const($8->variable);
																	error_message("The index is out of range!!!\n");
																}

																$$ = (struct Variable*)malloc(sizeof(struct Variable));
																$$->name = (char*)malloc(sizeof(char)*(strlen("@const") + 1));
																strcpy($$->name,"@const");
																$$->type = a->type;
																$$->size = 0;
																$$->value.valINT = 0;

																free_const($8->variable);
															}
				;

class_access_fun:
				  ID MEMBER_ACCESS ID '(' params_call ')'	{
																struct Variable* v = general_lookup($1);
																free($1);
																if(v==NULL){
																	free($3);
																	error_message("The variable is not declared!!!\n");
																}
																if(v->type>=INT){
																	free($3);
																	error_message("The variable has no members!!!\n");
																}
																if(v->size!=0){
																	free($3);
																	error_message("The variable must be an array!!!\n");
																}

																struct Class* class = classes[v->type];
																for(int i = 0; i < class->nr_functions; ++i){
																	if(strcmp(class->functions[i]->name, $3) == 0){
																		if(class->functions[i]->nr_parameters != nr_params){
																			free($3);
																			error_message("You provided the wrong number of parameters!!!\n");
																		}

																		for(int j = 0; j < class->functions[i]->nr_parameters; ++j){
																			if(class->functions[i]->parameters[j] != params[j]){
																				free($3);
																				error_message("The parameters are of wrong type!!!\n");
																			}
																			else
																				if(is_array[j]!=0 && class->functions[i]->size[j]==0 || ((is_array[j]!=0 && class->functions[i]->size[j]!=0) && class->functions[i]->size[j]<is_array[j] )){
																					free($3);
																					error_message("The parameters are of wrong type!!!\n");
																				}
																		}

																		$$ = (struct Variable*)malloc(sizeof(struct Variable));
																		$$->name = (char*)malloc((strlen("@const")+1)*sizeof(char));
																		strcpy($$->name, "@const");
																		$$->type = class->functions[i]->return_type;
																		$$->value.valINT = 0;
																	}
																}

																free(params);
																free(params_name);
																params = NULL;
																params_name = NULL;
																nr_params = 0;

																free($3);
															}
				| ID '[' item ']' MEMBER_ACCESS ID '(' params_call ')'	{
																free_AST($3->ast);
																struct Variable* v = general_lookup($1);
																free($1);
																if(v==NULL){
																	free($6);
																	free_const($3->variable);
																	error_message("The variable is not declared!!!\n");
																}
																if(v->type>=INT){
																	free($6);
																	free_const($3->variable);
																	error_message("The variable has no members!!!\n");
																}
																if(v->size==0){
																	free($6);
																	free_const($3->variable);
																	error_message("The variable is not an array!!!\n");
																}
																if($3->variable->type != INT || $3->variable->size != 0){
																	free($6);
																	free_const($3->variable);
																	error_message("Error: Invalid index!!!\n");
																}
																if($3->variable->value.valINT >= v->size || $3->variable->value.valINT < 0){
																	free($6);
																	free_const($3->variable);
																	error_message("The index is out of range!!!\n");
																}
																free_const($3->variable);

																struct Class* class = classes[v->type];
																for(int i = 0; i < class->nr_functions; ++i){
																	if(strcmp(class->functions[i]->name, $6) == 0){
																		if(class->functions[i]->nr_parameters != nr_params){
																			free($6);
																			error_message("You provided the wrong number of parameters!!!\n");
																		}

																		for(int j = 0; j < class->functions[i]->nr_parameters; ++j){
																			if(class->functions[i]->parameters[j] != params[j]){
																				free($6);
																				error_message("The parameters are of wrong type!!!\n");
																			}
																			else
																				if(is_array[j]!=0 && class->functions[i]->size[j]==0 || ((is_array[j]!=0 && class->functions[i]->size[j]!=0) && class->functions[i]->size[j]<is_array[j] )){
																					free($6);
																					error_message("The parameters are of wrong type!!!\n");
																				}
																		}

																		$$ = (struct Variable*)malloc(sizeof(struct Variable));
																		$$->name = (char*)malloc((strlen("@const")+1)*sizeof(char));
																		strcpy($$->name, "@const");
																		$$->type = class->functions[i]->return_type;
																		$$->value.valINT = 0;
																	}
																}

																free(params);
																free(params_name);
																params = NULL;
																params_name = NULL;
																nr_params = 0;

																free($6);
															}
				;

/*FUNCTION*/

function		: PROCEDURE ID 
							{	
								if(find_function_name($2) == 0){
									free($2);
									error_message("The function is already delcared!!!\n");
								}
								stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);

								if(current_class)
									for(int i = 0; i < current_class->nr_variables; ++i)
										add_element(peek(stack_scope[curr_pos]), current_class->variables[i]);

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
									free($2);
									error_message("The function is already delcared!!!\n");
								}
								stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);
								if(current_class)
									for(int i = 0; i < current_class->nr_variables; ++i)
										add_element(peek(stack_scope[curr_pos]), current_class->variables[i]);
										
								functions[nr_functions] = (struct Function*)malloc(sizeof(struct Function));
								functions[nr_functions]->name = (char*)malloc((strlen($2)+1)*sizeof(char));
								strcpy(functions[nr_functions]->name, $2);
								functions[nr_functions]->nr_parameters = 0;
							}
							'(' params ')' ARROW TYPE
													{
														functions[nr_functions]->return_type = $8;
													}
							 '{'function_block rtn '}'		
																				{	
																					if($12->type != $8){
																						error_message("The return type is incorect!!!\n");
																					}

																					
																					++nr_functions;
																					freeStack(stack_scope[curr_pos--]);
																				}
        		;

params 			: 
				  declaration ',' params	
				  							{
												if(general_lookup($1) != NULL){
													error_message("The variable is already declared!!!\n");
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
		
												add_element(peek(stack_scope[curr_pos]), $1); 
												write_to_file($1);
											}
       			| declaration 				{
												if(general_lookup($1) != NULL){
													error_message("The variable is already declared!!!\n");
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
		
												add_element(peek(stack_scope[curr_pos]), $1); 
												write_to_file($1);
											}
				|
       			;

function_block 	: function_block assignments ';'
				| function_block declaration 	{ 
													if(general_lookup($2->name) != NULL){
														add_element(peek(stack_scope[curr_pos]), $2);
														error_message("The variable is already declared!!!\n");
													}
													add_element(peek(stack_scope[curr_pos]), $2); 
													write_to_file($2); 
												}';'
				| function_block definition 	{ 
													if(general_lookup($2->name) != NULL){
														add_element(peek(stack_scope[curr_pos]), $2);
														error_message("The variable is already declared!!!\n");
													}
													add_element(peek(stack_scope[curr_pos]), $2); 
													write_to_file($2); 
												}';'
				| function_block function_call ';'
				| function_block class_access_fun ';'
				| function_block while
				| function_block for
				| function_block if
				| function_block TYPEOF '(' operations ')' ';' 	
							{
								//free_AST($4->ast);
								char* name;
								switch ($4->variable->type)
								{
									case INT:
										name = (char*)"int";
										break;
									case FLOAT:
										name = (char*)"float";
										break;
									case CHAR:
										name = (char*)"char";
										break;
									case STRING:
										name = (char*)"string";
										break;
									case BOOL:
										name = (char*)"bool";
										break;
									default:
										name = classes[$4->variable->type]->name;
										break;
								}

								if($4->variable->size == 0)
									printf("Type: %s;\n", name);
								else
									printf("Type: %s[%d];\n", name, $4->variable->size);

							}
				| function_block EVAL '(' operations ')' ';' {printf("Eval output: %d;\n", eval_AST($4->ast));}
				|
				;

rtn 			: RETURN item ';' {$$ = $2->variable; free_AST($2->ast);}
				;

function_call   : 
				  ID 	{
							if(find_function_name2($1) == -1){
								error_message("The function has not been declared!!!\n");
							}		
						} 
						'(' params_call ')'	{
												for(int i = 0; i <= nr_functions; ++i){
													if(strcmp(functions[i]->name, $1) == 0){
														if(functions[i]->nr_parameters != nr_params){
															error_message("You provided the wrong number of parameters!!!\n");
														}

														for(int j = 0; j < functions[i]->nr_parameters; ++j){
															if(functions[i]->parameters[j] != params[j]){
																error_message("The parameters are of wrong type!!!\n");
															}
															else
																if(is_array[j]!=0 && functions[i]->size[j]==0 || ((is_array[j]!=0 && functions[i]->size[j]!=0) && functions[i]->size[j]<is_array[j] )){
																	error_message("The parameters are of wrong type!!!\n");
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
												free_AST($1->ast);
												int* temp = (int*)malloc(sizeof(int) * (nr_params+1));
												int* temp2 = (int*)malloc(sizeof(int) * (nr_params+1));
												if(nr_params > 0)
												{
													memcpy(temp, params, sizeof(int) * nr_params);
													memcpy(temp2, is_array, sizeof(int) * nr_params);
												}
												temp[nr_params++] = $1->variable->type;
												if($1->variable->size!=0)
													temp2[nr_params-1]=$1->variable->size;
												else
													temp2[nr_params-1]=$1->variable->size;
												free_const($1->variable);

												free(params);
												free(is_array);
												params = temp;
												is_array=temp2;
											}
				| operations 				{
												free_AST($1->ast);
												int* temp = (int*)malloc(sizeof(int) * (nr_params+1));
												int* temp2 = (int*)malloc(sizeof(int) * (nr_params+1));
												if(nr_params > 0)
												{
													memcpy(temp, params, sizeof(int) * nr_params);
													memcpy(temp2, is_array, sizeof(int) * nr_params);
												}
												temp[nr_params++] = $1->variable->type;
												if($1->variable->size!=0)
													temp2[nr_params-1]=$1->variable->size;
												else
													temp2[nr_params-1]=$1->variable->size;
												free_const($1->variable);

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
															if($4 <= 0){
																error_message("The index cannot be negative or zero!!!\n");
															}
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
																error_message("Invalid type!!!\n");
															}

															$$ = (struct Variable*)malloc(sizeof(struct Variable));
															$$->name = $2;
															$$->type = type;
															$$->is_const = 0;
															$$->size = 0;
															$$->value.valINT = 0;
														}
				| ID ID '[' INT_CONST ']'				{
															if($4 <= 0){
																error_message("The index cannot be negative or zero!!!\n");
															}
															int type = 0;

															if((type = find_class_name($1)) == -1){
																error_message("Invalid type!!!\n");
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
																	
															if($2 != $5->variable->type || $5->variable->size!=0){
																free($3);
																free_const($5->variable);
																error_message("The types are incompatible!!!\n");
															}

															if(strcmp($5->variable->name, "@const") == 0){
																$$ = $5->variable;
																$$->name = $3;
																$$->is_const = 1;
															}
															else{
																$$ = (struct Variable*)malloc(sizeof(struct Variable));
																$$->name = $3;
																$$->type = $2;
																$$->is_const = 1;

																if($2 == STRING){
																	$$->value.valSTRING = (char*)malloc((strlen($5->variable->value.valSTRING) + 1) * sizeof(char));
																	strcpy($$->value.valSTRING, $5->variable->value.valSTRING);
																}
																if($2 == INT){
																	$$->value.valINT = eval_AST($5->ast);
																}
																else{
																	$$->value.valINT = 0;
																	memcpy(&$$->value, &$5->variable->value, sizeof($5->variable->value)); 
																}
															}

															$$->size = 0;
															free_const($5->variable);
														}
				| TYPE ID ASSIGN operations				{
															if($1 != $4->variable->type || $4->variable->size!=0){
																free($2);
																free_const($4->variable);
																error_message("The types are incompatible!!!\n");
															}

															if(strcmp($4->variable->name, "@const") == 0){
																$$ = $4->variable;
																$$->name = $2;
																$$->is_const = 0;
															}
															else{
																$$ = (struct Variable*)malloc(sizeof(struct Variable));
																$$->name = $2;
																$$->type = $1;
																$$->is_const = 0;

																if($1 == STRING){
																	$$->value.valSTRING = (char*)malloc((strlen($4->variable->value.valSTRING) + 1) * sizeof(char));
																	strcpy($$->value.valSTRING, $4->variable->value.valSTRING);
																}
																if($1 == INT){
																	$$->value.valINT = eval_AST($4->ast);
																}
																else{
																	$$->value.valINT = 0;
																	memcpy(&$$->value, &$4->variable->value, sizeof($4->variable->value)); 
																}
															}
															
															free_const($4->variable);
															$$->size = 0;
														}
				| CONST TYPE ID '[' INT_CONST ']' 	{
														if($5 <= 0){
															free($3);
															error_message("The index cannot be negative or zero!!!\n");
														}
														array_type = $2;
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
														if($4 <= 0){
															free($2);
															error_message("The index cannot be negative or zero!!!\n");
														}
														array_type = $1;
													} ASSIGN '{' arr_item'}' 
																				{
																					if(nr_items > $4){
																						free($2);
																						error_message("There are more elements in the array than you declared!!!\n");
																					}
																					$$ = (struct Variable*)malloc(sizeof(struct Variable));
																					$$->name = $2;
																					$$->type = $1;
																					$$->is_const = 0;			
																					$$->value.valINT = 0;
																					$$->size = $4;
																					array_type = 0;
																					nr_items=0;
																				}
				;

arr_item		:
				  operations ',' arr_item 	{
												if($1->variable->type != array_type){
													free_const($1->variable);
													error_message("The elements of the array are not as the same type as the array!!!\n");
												}
												nr_items++;
											}
				| operations				{
												if($1->variable->type != array_type){
													free_const($1->variable);
													error_message("The elements of the array are not as the same type as the array!!!\n");
												}
												nr_items++;
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
									$$->size = 0;
								}
				| FLOAT_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									$$->name = (char*)malloc(strlen("@const") + 1);
									strcpy($$->name, "@const");
									$$->type = FLOAT;
									$$->value.valFLOAT = $1;
									$$->size = 0;
								}
				| STRING_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									$$->name = (char*)malloc(strlen("@const") + 1);
									strcpy($$->name, "@const");
									$$->type = STRING;
									$$->value.valSTRING = (char*)malloc((strlen($1) - 1) * sizeof(char));
									$1[strlen($1) - 1] = '\0';
									strcpy($$->value.valSTRING, $1 + 1);
									$$->size = 0;
								}
				| CHAR_CONST	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									$$->name = (char*)malloc(strlen("@const") + 1);
									strcpy($$->name, "@const");
									$$->type = CHAR;
									$$->value.valCHAR = $1;
									$$->size = 0;
								}
				| BOOL_CONST 	{
									$$ = (struct Variable*)malloc(sizeof(struct Variable));
									$$->name = (char*)malloc(strlen("@const") + 1);
									strcpy($$->name, "@const");
									$$->type = BOOL;
									$$->value.valBOOL = $1;
									$$->size = 0;
								}
				;

assignments		: assignment 
      			| assignments assignment 
				| 
      			;

assignment		: 
				  ID ASSIGN operations		{
												
												struct Variable* v = general_lookup($1);
												free($1);

												if(v == NULL || v->is_const == 1){
													free_const($3->variable);
													error_message("The variable is not declared or is const!!!\n");
												}

												if(v->type != $3->variable->type || $3->variable->size!=0 || v->size!=0){
													free_const($3->variable);
													error_message("The types are not compatible!!!\n");
												}
											
												if(v->type == STRING){
													v->value.valSTRING = (char*)malloc((strlen($3->variable->value.valSTRING) + 1) * sizeof(char));
													strcpy(v->value.valSTRING, $3->variable->value.valSTRING);
												}
												else if(v->type == INT){
													v->value.valINT = eval_AST($3->ast);
												}
												else{
													v->value.valINT = 0;
													memcpy(&v->value, &$3->variable->value, sizeof($3->variable->value)); 
												}

												free_const($3->variable);
											}	
				| ID ASSIGN ID '[' item ']'	{
												free_AST($5->ast);
												if($5->variable->type != INT || $5->variable->size != 0){
													free_const($5->variable);
													error_message("Error: Invalid index!!!\n");
												}

												struct Variable* v = general_lookup($1);
												struct Variable* a = general_lookup($3);

												free($1);
												free($3);

												if(v == NULL || a == NULL || v->is_const == 1){
													free_const($5->variable);
													error_message("The variable is not declared or is const!!!\n");
												}

												if(v->type != a->type || a->size==0 || v->size!=0){
													free_const($5->variable);
													error_message("The types are not compatible!!!\n");
												}
											
												if($5->variable->value.valINT >= a->size || $5->variable->value.valINT < 0){
													free_const($5->variable);
													error_message("The index is out of range!!!\n");
												}

												free_const($5->variable);
											}
				| ID INCREMENT				{
												struct Variable* v = general_lookup($1);
												free($1);

												if(v == NULL){
													error_message("The variable is not declared!!!\n");
												}

												if((v->type != INT) && (v->type != CHAR) && (v->type != FLOAT) && (v->is_const == 1)){
													error_message("Cannot increment this variable!!!\n");
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
												free($1);

												if(v == NULL){
													error_message("The variable is not declared!!!\n");
												}
												if((v->type != INT) && (v->type != CHAR) && (v->type != FLOAT) && (v->is_const == 1)){
													error_message("Cannot decrement this variable!!!\n");
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
												free_AST($3->ast);
												if($3->variable->type != INT || $3->variable->size != 0){
													free($1);
													free_const($6->variable);
													free_const($3->variable);
													error_message("Error: Invalid index!!!\n");
												}

												struct Variable* v = general_lookup($1);
												free($1);

												if(v == NULL || v->is_const == 1){
													free_const($6->variable);
													free_const($3->variable);
													error_message("The variable is not declared or is const!!!\n");
												}
												if(v->type != $6->variable->type || $6->variable->size!=0){
													free_const($6->variable);
													free_const($3->variable);
													error_message("The types are not compatible!!!\n");
												}
												if($3->variable->value.valINT >= v->size || $3->variable->value.valINT < 0){
													free_const($6->variable);
													free_const($3->variable);
													error_message("The index is out of range!!!\n");
												}

												free_const($6->variable);
												free_const($3->variable);
											}
				| ID '[' item ']' ASSIGN ID '[' item ']'
											{
												free_AST($3->ast);
												free_AST($8->ast);
												if($3->variable->type != INT || $3->variable->size != 0 || $8->variable->type != INT || $8->variable->size != 0){
													free($1);
													free($6);
													free_const($3->variable);
													free_const($8->variable);
													error_message("Error: Invalid index!!!\n");
												}

												struct Variable* a1 = general_lookup($1);
												struct Variable* a2 = general_lookup($6);
												free($1);
												free($6);

												if(a1 == NULL || a2 == NULL || a1->is_const == 1){
													free_const($3->variable);
													free_const($8->variable);
													error_message("The variable is not declared or is const!!!\n");
												}
												if(a1->type != a2->type){
													free_const($3->variable);
													free_const($8->variable);
													error_message("The types are not compatible!!!\n");
												}
												if($3->variable->value.valINT >= a1->size || $3->variable->value.valINT < 0 || $8->variable->value.valINT >= a2->size || $8->variable->value.valINT < 0){
													free_const($3->variable);
													free_const($8->variable);
													error_message("The index is out of range!!!\n");
												}

												free_const($3->variable);
												free_const($8->variable);
											}
				| class_access_var ASSIGN operations
												{	
													if($1->type != $3->variable->type || $3->variable->size!=0){
														free_const($3->variable);
														free_AST($3->ast);
														error_message("The types are not compatible!!!\n");
													}
												
													if($1->type == STRING){
														$1->value.valSTRING = (char*)malloc((strlen($3->variable->value.valSTRING) + 1) * sizeof(char));
														strcpy($1->value.valSTRING, $3->variable->value.valSTRING);
													}
													else if($1->type == INT){
														$1->value.valINT = eval_AST($3->ast);
													}
													else{
														$1->value.valINT = 0;
														memcpy(&$1->value, &$3->variable->value, sizeof($3->variable->value)); 
													}

													free_const($3->variable);
													free_AST($3->ast);
												}
		        | class_access_var ASSIGN ID '[' item ']'
											{
														free_AST($5->ast);
														if($5->variable->type != INT || $5->variable->size != 0){
															free_const($5->variable);
															error_message("Error: Invalid index!!!\n");
														}
														struct Variable* a = general_lookup($3);
														free($3);

														if(a == NULL){
															free_const($5->variable);
															error_message("The variable is not declared or is const!!!\n");
														}
														if($1->type != a->type || a->size==0 ){
															free_const($5->variable);
															error_message("The types are not compatible!!!\n");
														}
													
														if($5->variable->value.valINT >= a->size || $5->variable->value.valINT < 0){
															free_const($5->variable);
															error_message("The index is out of range!!!\n");
														}

														free_const($5->variable);
											}
				;


operations 		: item 							{$$ = $1;}
				| bool_statement				{
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->variable = (struct Variable*)malloc(sizeof(struct Variable));
													$$->variable->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->variable->name, "@const");
													$$->variable->type = BOOL;
													$$->variable->value.valBOOL = $1;

													$$->ast = NULL;												
												}
				| operations PLUS operations 	{
													int compatible = 1;
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->ast = NULL;
													$$->variable = (struct Variable*)malloc(sizeof(struct Variable));
													$$->variable->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->variable->name, "@const");
													
													if($1->variable->size!=0 || $3->variable->size!=0)
														compatible=0;
													else
													{
														if($1->variable->type == INT && $3->variable->type == INT){
															$$->variable->type = INT;
															$$->variable->value.valINT = $1->variable->value.valINT + $3->variable->value.valINT;


															$$->ast = build_AST("+", $1->ast, $3->ast, OP);
														}
														else if($1->variable->type == FLOAT && $3->variable->type == FLOAT){
															$$->variable->type = FLOAT;
															$$->variable->value.valFLOAT = $1->variable->value.valFLOAT + $3->variable->value.valFLOAT;

															free_AST($1->ast);
															free_AST($3->ast);
														}
														else if($1->variable->type == STRING && $3->variable->type == STRING){
															$$->variable->type = STRING;
															int size = (strlen($1->variable->value.valSTRING) + strlen($3->variable->value.valSTRING) + 1) * sizeof(char);
															$$->variable->value.valSTRING = (char*)malloc(size);
															strcpy($$->variable->value.valSTRING, $1->variable->value.valSTRING);
															strcat($$->variable->value.valSTRING, $3->variable->value.valSTRING);

															free_AST($1->ast);
															free_AST($3->ast);
														}
														else{
															compatible = 0;
														}
													}

													free_const($1->variable);
													free_const($3->variable);

													if(compatible == 0){
														error_message("These types can't be added!!!\n");
													}

												}
				| operations MINUS operations	{
													int compatible = 1;
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->ast = NULL;
													$$->variable = (struct Variable*)malloc(sizeof(struct Variable));
													$$->variable->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->variable->name, "@const");
													if($1->variable->size!=0 || $3->variable->size!=0)
														compatible=0;
													else
														{
															if($1->variable->type == INT && $3->variable->type == INT){
																$$->variable->type = INT;
																$$->variable->value.valINT = $1->variable->value.valINT - $3->variable->value.valINT;

																$$->ast = build_AST("-", $1->ast, $3->ast, OP);
															}
															else if($1->variable->type == FLOAT && $3->variable->type == FLOAT){
																$$->variable->type = FLOAT;
																$$->variable->value.valFLOAT = $1->variable->value.valFLOAT - $3->variable->value.valFLOAT;
																free_AST($1->ast);
																free_AST($3->ast);
															}
															else{
																compatible = 0;
															}
														}

													free_const($1->variable);
													free_const($3->variable);

													if(compatible == 0){
														error_message("These types can't be subtracted!!!\n");
													}
												}
				| operations SLASH operations	{
													int compatible = 1;
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->ast = NULL;
													$$->variable = (struct Variable*)malloc(sizeof(struct Variable));
													$$->variable->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->variable->name, "@const");
													if($1->variable->size!=0 || $3->variable->size!=0)
														compatible=0;
													else
													{	
														if(($1->variable->type == INT && $3->variable->type == INT)){
															$$->variable->type = INT;
															$$->variable->value.valINT = ($1->variable->value.valINT / $3->variable->value.valINT);

															$$->ast = build_AST("/", $1->ast, $3->ast, OP);
														}
														else if($1->variable->type == FLOAT && $3->variable->type == FLOAT){
															$$->variable->type = FLOAT;
															$$->variable->value.valFLOAT = $1->variable->value.valFLOAT / $3->variable->value.valFLOAT;

															free_AST($1->ast);
															free_AST($3->ast);
														}
														else{
															compatible = 0;
														}

														free_const($1->variable);
														free_const($3->variable);

														if(compatible == 0){
															error_message("These types can't be divided!!!\n");
														}
													}
												}
				| operations MULT operations	{
													int compatible = 1;
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->ast = NULL;
													$$->variable = (struct Variable*)malloc(sizeof(struct Variable));
													$$->variable->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->variable->name, "@const");
													if($1->variable->size!=0 || $3->variable->size!=0)
														compatible=0;
													else
													{	
														if($1->variable->type == INT && $3->variable->type == INT){
															$$->variable->type = INT;
															$$->variable->value.valINT = $1->variable->value.valINT * $3->variable->value.valINT;

															$$->ast = build_AST("*", $1->ast, $3->ast, OP);
														}
														else if($1->variable->type == FLOAT && $3->variable->type == FLOAT){
															$$->variable->type = FLOAT;
															$$->variable->value.valFLOAT = $1->variable->value.valFLOAT * $3->variable->value.valFLOAT;

															free_AST($1->ast);
															free_AST($3->ast);
														}
														else{
															compatible = 0;
														}
													}

													free_const($1->variable);
													free_const($3->variable);

													if(compatible == 0){
														error_message("These types can't be multiplyed!!!\n");
													}
												}
				| operations REMAIDER operations {
													int compatible = 1;
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->ast = NULL;
													$$->variable = (struct Variable*)malloc(sizeof(struct Variable));
													$$->variable->name = (char*)malloc(strlen("@const") + 1);
													strcpy($$->variable->name, "@const");
													if($1->variable->size!=0 || $3->variable->size!=0)
														compatible=0;
													else
														{	
															if(($1->variable->type == INT && $3->variable->type == INT)){
																$$->variable->type = INT;
																$$->variable->value.valINT = $1->variable->value.valINT % $3->variable->value.valINT;

																$$->ast = build_AST("%", $1->ast, $3->ast, OP);
															}
															else{
																compatible = 0;
															}
														}

													free_const($1->variable);
													free_const($3->variable);

													if(compatible == 0){
														error_message("These types can't be divided!!!\n");
													}
												}
				| '(' operations ')'			{ $$ = $2;}
				| function_call					{
													if($1->type == -1){
														free_const($1);
														error_message("Procedures don't return any value!!!\n");
													}
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->variable = $1;
												}
				| class_access_var				{
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->variable = $1;
												}
				| class_access_fun				{
													$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
													$$->variable = $1;	
												}

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
												free_AST($1->ast);
												if($1->variable->type != BOOL){
													free_const($1);
													error_message("Thise variables is not of type bool!!!\n");
												}

												$$ = $1->variable->value.valBOOL;
												free_const($1);
											}
				| item NEQ item 			{
												free_AST($1->ast);
												free_AST($3->ast);
												if($1->variable->type != $3->variable->type || $1->variable->size != 0 || $3->variable->size != 0){
													free_const($1->variable);
													free_const($3->variable);
													error_message("These types can't be compared!!!\n");
												}

												if($1->variable->type == STRING)
													$$ = strcmp($1->variable->value.valSTRING, $3->variable->value.valSTRING) != 0;
												else
													$$ = ($1->variable->type == INT) ? $1->variable->value.valINT != $3->variable->value.valINT 
														: ($1->variable->type == FLOAT) ? $1->variable->value.valFLOAT != $3->variable->value.valFLOAT
														: ($1->variable->type == CHAR) ? $1->variable->value.valCHAR != $3->variable->value.valCHAR
														: ($1->variable->type == BOOL) ? $1->variable->value.valBOOL != $3->variable->value.valBOOL : 0;

												free_const($1->variable);
												free_const($3->variable);
											}
				| item EQ item				{
												free_AST($1->ast);
												free_AST($3->ast);
												if($1->variable->type != $3->variable->type || $1->variable->size!=0 || $3->variable->size!=0){
													free_const($1->variable);
													free_const($3->variable);
													error_message("These types can't be compared!!!\n");
												}

												if($1->variable->type == STRING)
													$$ = strcmp($1->variable->value.valSTRING, $3->variable->value.valSTRING) == 0;
												else
													$$ = ($1->variable->type == INT) ? $1->variable->value.valINT == $3->variable->value.valINT 
														: ($1->variable->type == FLOAT) ? $1->variable->value.valFLOAT == $3->variable->value.valFLOAT
														: ($1->variable->type == CHAR) ? $1->variable->value.valCHAR == $3->variable->value.valCHAR
														: ($1->variable->type == BOOL) ? $1->variable->value.valBOOL == $3->variable->value.valBOOL : 0;

												free_const($1->variable);
												free_const($3->variable);
											}

				| item LESS item			{
												free_AST($1->ast);
												free_AST($3->ast);
												if($1->variable->type != $3->variable->type || $1->variable->size!=0 || $3->variable->size!=0){
													free_const($1->variable);
													free_const($3->variable);
													error_message("These types can't be compared!!!\n");
												}

												if($1->variable->type == STRING)
													$$ = strcmp($1->variable->value.valSTRING, $3->variable->value.valSTRING) < 0;
												else
													$$ = ($1->variable->type == INT) ? $1->variable->value.valINT < $3->variable->value.valINT 
														: ($1->variable->type == FLOAT) ? $1->variable->value.valFLOAT < $3->variable->value.valFLOAT
														: ($1->variable->type == CHAR) ? $1->variable->value.valCHAR < $3->variable->value.valCHAR
														: ($1->variable->type == BOOL) ? $1->variable->value.valBOOL < $3->variable->value.valBOOL : 0;

												free_const($1->variable);
												free_const($3->variable);
											}
				| item LESSOREQ item		{
												free_AST($1->ast);
												free_AST($3->ast);
												if($1->variable->type != $3->variable->type || $1->variable->size!=0 || $3->variable->size!=0){
													free_const($1->variable);
													free_const($3->variable);
													error_message("These types can't be compared!!!\n");
												}

												if($1->variable->type == STRING)
													$$ = strcmp($1->variable->value.valSTRING, $3->variable->value.valSTRING) <= 0;
												else
													$$ = ($1->variable->type == INT) ? $1->variable->value.valINT <= $3->variable->value.valINT 
														: ($1->variable->type == FLOAT) ? $1->variable->value.valFLOAT <= $3->variable->value.valFLOAT
														: ($1->variable->type == CHAR) ? $1->variable->value.valCHAR <= $3->variable->value.valCHAR
														: ($1->variable->type == BOOL) ? $1->variable->value.valBOOL <= $3->variable->value.valBOOL : 0;

												free_const($1->variable);
												free_const($3->variable);
											}
				| item GREATER item			{
												free_AST($1->ast);
												free_AST($3->ast);
												if($1->variable->type != $3->variable->type || $1->variable->size!=0 || $3->variable->size!=0){
													free_const($1->variable);
													free_const($3->variable);
													error_message("These types can't be compared!!!\n");
												}

												if($1->variable->type == STRING)
													$$ = strcmp($1->variable->value.valSTRING, $3->variable->value.valSTRING) > 0;
												else
													$$ = ($1->variable->type == INT) ? $1->variable->value.valINT > $3->variable->value.valINT 
														: ($1->variable->type == FLOAT) ? $1->variable->value.valFLOAT > $3->variable->value.valFLOAT
														: ($1->variable->type == CHAR) ? $1->variable->value.valCHAR > $3->variable->value.valCHAR
														: ($1->variable->type == BOOL) ? $1->variable->value.valBOOL > $3->variable->value.valBOOL : 0;

												free_const($1->variable);
												free_const($3->variable);
											}
				| item GREATEROREQ item		{
												free_AST($1->ast);
												free_AST($3->ast);
												if($1->variable->type != $3->variable->type || $1->variable->size!=0 || $3->variable->size!=0){
													free_const($1->variable);
													free_const($3->variable);
													error_message("These types can't be compared!!!\n");
												}

												if($1->variable->type == STRING)
													$$ = strcmp($1->variable->value.valSTRING, $3->variable->value.valSTRING) >= 0;
												else
													$$ = ($1->variable->type == INT) ? $1->variable->value.valINT >= $3->variable->value.valINT 
														: ($1->variable->type == FLOAT) ? $1->variable->value.valFLOAT >= $3->variable->value.valFLOAT
														: ($1->variable->type == CHAR) ? $1->variable->value.valCHAR >= $3->variable->value.valCHAR
														: ($1->variable->type == BOOL) ? $1->variable->value.valBOOL >= $3->variable->value.valBOOL : 0;

												free_const($1->variable);
												free_const($3->variable);
											}
				;

item            : 
				ID {
						$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
						$$->variable = general_lookup($1);
						if($$->variable == NULL){
							error_message("The variable is not declared!!!\n");
						}
						if($$->variable->type == INT)
							$$->ast = build_AST($1, NULL, NULL, IDENTIFIER);
						else
							$$->ast = NULL;
						free($1);
					}
				| constant_value	{
										$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
										$$->variable = $1;
										if($$->variable->type == INT){
											$$->ast = build_AST(&$1->value.valINT, NULL, NULL, NUMBER);
										}
										else
											$$->ast = NULL;
									}
				| class_access_var	{
										$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
										$$->variable = $1;
										if($$->variable->type == INT)
											$$->ast = build_AST(&$1->value.valINT, NULL, NULL, NUMBER);
										else
											$$->ast = NULL;
									}
				| ID '[' item ']' 			{	
												$$ = (struct AST_VAR*)malloc(sizeof(struct AST_VAR));
												
												struct Variable* a = general_lookup($1);
												free($1);
												if(a == NULL){
													free_const($3->variable);
													free_AST($3->ast);
													error_message("The variable is not declared or is const!!!\n");
												}

												if(a->size==0 ){
													free_const($3->variable);
													free_AST($3->ast);
													error_message("The types are not compatible!!!\n");
												}

												if($3->variable->type != INT){
													free_const($3->variable);
													free_AST($3->ast);
													error_message("The index is of the wrong type!!!\n");
												}
											
												if($3->variable->value.valINT >= a->size || $3->variable->value.valINT < 0){
													free_const($3->variable);
													free_AST($3->ast);
													error_message("The index is out of range!!!\n");
												}

												$$->variable = (struct Variable*)malloc(sizeof(struct Variable));
												$$->variable->name = (char*)malloc(sizeof(char)*(strlen("@const") + 1));
												strcpy($$->variable->name,"@const");
												$$->variable->type = a->type;
												$$->variable->size = 0;
												$$->variable->value.valINT = 0;
	

												if($$->variable->type == INT)
													$$->ast = build_AST(&$$->variable->value.valINT, NULL, NULL, NUMBER);
												else
													$$->ast = NULL;


												free_const($3->variable);
												free_AST($3->ast);
											}
				;
				

while  			: WHILE '(' bool_statement ')' {push(stack_scope[curr_pos]);} '{' function_block '}' { 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									 }
				;

for				: 
				  FOR '(' definition ';' bool_statement ';' assignment ')' {push(stack_scope[curr_pos]);} '{' function_block '}'{ 	
																																	struct Node* n = pop(stack_scope[curr_pos]);
																																	delete_list(&n);
																																}
				| FOR '(' assignment ';' bool_statement ';' assignment ')' {push(stack_scope[curr_pos]);} '{' function_block '}'{ 	
																																	struct Node* n = pop(stack_scope[curr_pos]);
																																	delete_list(&n);
																																}
				;

if 				: 
				  IF '(' bool_statement ')' {push(stack_scope[curr_pos]);} '{' function_block '}' 	{ 	
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
				fprintf(fp, "Type: %s, ", classes[var->type]->name);
				break;
		}
	}
	else{
		fprintf(fp, "Array name: %s,", var->name);
		switch (var->type)
		{
			case INT:
				fprintf(fp, "Type: int, ");
				break;
			case FLOAT:
				fprintf(fp, "Type: float, ");
				break;
			case CHAR:
				fprintf(fp, "Type: char, ");
				break;
			case STRING:
				fprintf(fp, "Type: string, ");
				break;
			case BOOL:
				fprintf(fp, "Type: bool, ");
				break;
			default:
				fprintf(fp, "Type: %s, ", classes[var->type]->name);
				break;
		}

		fprintf(fp, "Size: %d; ", var->size);
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

void free_classes()
{
	for(int i = 0; i < nr_classes; ++i){
		for(int j = 0; j < classes[i]->nr_variables; ++j){
			if(classes[i]->variables[j]->type == STRING)
				free(classes[i]->variables[j]->value.valSTRING);
			free(classes[i]->variables[j]->name);
			free(classes[i]->variables[j]);
		}

		for(int j = 0; j < classes[i]->nr_functions; ++j){
			free(classes[i]->functions[j]->name);
			free(classes[i]->functions[j]->parameters);
			free(classes[i]->functions[j]);
		}

		free(classes[i]->name);
		free(classes[i]);
	}
}

int yyerror(char * s){
	printf("\033[0;31mError: %s at line: %d;\033[0m\n",s,yylineno);
}

int main(int argc, char** argv){
	yyin=fopen(argv[1],"r");
	yyparse();
} 