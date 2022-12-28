#ifndef INCLUDES_H
#define INCLUDES_H 

typedef union Value{
	int valINT;
	float valFLOAT;
	char valCHAR;
	char* valSTRING;
	int valBOOL;
} Value;


typedef struct Variable{
	char name[100];
	int type;
	int is_const;
	union Value value;
} Variable;

#endif