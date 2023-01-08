#ifndef AST_TREE_H
#define AST_TREE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "includes.h"

struct Variable* general_lookup(const char* name);


typedef enum {
  NUMBER,
  IDENTIFIER,
  OP,
} NodeType;


typedef struct AstNode {
  NodeType type;
  union {
    int number;
    char* identifier;
    char op;
  } value;
  struct AstNode* left;
  struct AstNode* right;
} AstNode;


AstNode* build_AST(void* root, AstNode* left_tree, AstNode* right_tree, NodeType type)
{
    if (type == NUMBER && !root) {
        fprintf(stderr, "Error: NUMBER root must not be NULL\n");
        return NULL;
    } else if (type == IDENTIFIER && !root) {
        fprintf(stderr, "Error: IDENTIFIER root must not be NULL\n");
        return NULL;
    } else if (type == OP && !root) {
        fprintf(stderr, "Error: OP root must not be NULL\n");
        return NULL;
    }
    
    AstNode* ast = malloc(sizeof(AstNode));
    ast->type = type;
    ast->left = left_tree;
    ast->right = right_tree;
    switch (type) {
        case NUMBER:
            ast->value.number = *((int*) root);
            break;
        case IDENTIFIER:
            ast->value.identifier = strdup((char*) root);
            break;
        case OP:
            ast->value.op = *((char*) root);
            break;
        default:
            break;
    }
    return ast;
}


void free_AST(AstNode* ast) {
    if (!ast) 
        return;
    free_AST(ast->left);
    free_AST(ast->right);
    if (ast->type == IDENTIFIER) {
        free(ast->value.identifier);
    }
    free(ast);
}

int eval_AST(AstNode* ast) {
    if (!ast) return 0;

    switch (ast->type) {
        case NUMBER:
            return ast->value.number;
        case IDENTIFIER:
            printf("%d\n", general_lookup(ast->value.identifier)->value.valINT);
            return (general_lookup(ast->value.identifier)->value.valINT);
        case OP:
            switch (ast->value.op) {
                case '+':
                    return eval_AST(ast->left) + eval_AST(ast->right);
                case '-':
                    return eval_AST(ast->left) - eval_AST(ast->right);
                case '*':
                    return eval_AST(ast->left) * eval_AST(ast->right);
                case '/':
                    return eval_AST(ast->left) / eval_AST(ast->right);
                default:
                    fprintf(stderr, "Error: Unsupported operator\n");
                return 0;
            }
        default:
            return 0;
    }
}


#endif