#ifndef STACK_H
#define STACK_H

#include "includes.h"
#include "stdlib.h"
#define MAX_SIZE 100

struct Stack
{
  struct Node* data[MAX_SIZE];
  int top;
};

struct Stack *createStack()
{
  struct Stack *stack = (struct Stack *)malloc(sizeof(struct Stack));
  stack->top = -1;
  return stack;
}

int isEmpty(struct Stack *stack)
{
  return stack->top == -1;
}

void push(struct Stack *stack)
{
  stack->data[++stack->top] = NULL;
}

struct Node *pop(struct Stack *stack)
{
  if (isEmpty(stack))
    return NULL;

  return stack->data[stack->top--];
}

struct Node** peek(struct Stack *stack)
{
  if (isEmpty(stack))
    return NULL;

  return &stack->data[stack->top];
}

void freeStack(struct Stack *stack)
{
  struct Node* s = pop(stack);
  while(!stack){
    s = pop(stack);
    delete_list(&s);
    free(s);
  }

  free(stack);
  stack = NULL;
}

#endif