#ifndef INCLUDES_H
#define INCLUDES_H

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
	char name[100];
	int type;
	int is_const;
	union Value value;
} Variable;

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

void remove_element(struct Node **head, const char *name)
{
	struct Node *current = *head;
	struct Node *previous = NULL;
	while (current != NULL && current->variable->name != name)
	{
		previous = current;
		current = current->next;
	}
	if (current == NULL)
		return;
	if (previous == NULL)
		*head = current->next;
	else
		previous->next = current->next;

	free(current);
}

void delete_list(struct Node **head)
{
	struct Node *current = *head;
	while (current != NULL)
	{
		struct Node *temp = current;
		current = current->next;
		free(temp->variable);
		free(temp);
	}
	*head = NULL;
}

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