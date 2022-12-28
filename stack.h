#ifndef STACK_H
#define STACK_H

#include "includes.h"
#include "stdlib.h"
#define MAX_SIZE 100


struct Stack {
  struct Variable* data[MAX_SIZE];
  int top;
};


struct Stack* createStack() {
  struct Stack* stack = (struct Stack*) malloc(sizeof(struct Stack));
  stack->top = -1;
  return stack;
}


int isEmpty(struct Stack* stack) {
  return stack->top == -1;
}


void push(struct Stack* stack) {
  stack->data[++stack->top] = (struct Variable*)malloc(sizeof(struct Variable) * MAX_SIZE);
}


struct Variable* pop(struct Stack* stack) {
  if (isEmpty(stack)) {
    return NULL;
  }
  return stack->data[stack->top--];
}


struct Variable* peek(struct Stack* stack) {
  if (isEmpty(stack)) {
    return NULL;
  }
  return stack->data[stack->top];
}

#endif