#ifndef INCLUDES_H
#define INCLUDES_H

typedef struct Function
{
	char* name;
	int return_type;
	char** parameters_name; 
	int* parameters;
	int nr_parameters;
	int* size;
} Function;


typedef union Value
{
	int valINT;
	float valFLOAT;
	char valCHAR;
	char *valSTRING;
	int valBOOL;
} Value;

typedef struct Variable
{
	char* name;
	int type;
	int is_const;
	int size;
	union Value value;
} Variable;


typedef struct Class
{
	char* name;
	struct Variable* variables[10];
	int nr_variables;
	struct Function* functions[10];
	int nr_functions;
} Class;

typedef struct Node
{
	struct Node *next;
	struct Variable *variable;
} Variables;

void add_element(struct Node **head, struct Variable *variable)
{
	struct Node *new_node = (struct Node *)malloc(sizeof(struct Node));
	new_node->variable = variable;
	new_node->next = *head;
	*head = new_node;
}

void delete_list(struct Node **head);

struct Variable* lookup_element(struct Node *head, const char* name)
{
	struct Node *current = head;
	while (current != NULL && strcmp(current->variable->name, name) != 0)
		current = current->next;

	if (current == NULL)
		return NULL;

	return current->variable;
}

#endif