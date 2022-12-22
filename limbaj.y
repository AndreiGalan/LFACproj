%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

char variabila[10];
char tip[10];
char var_globale[1000][1000];
int nr_globale = 0;
struct table{
	char type[10];
	char nume[20];
	int valoareVar;
	char scope[10];	
	char valoareString[100];
  } obj;
%}
%union 
{ 
  int valINT;
  float valFLOAT;
  char valCHAR;
  char* valSTRING;
  int valBOOL;
}
%token TYPE SINGLECHAR CONST BEGIN END IF ELSE WHILE FOR CLASS CLASS_SPEC TRUE FALSE LESS LESSOREQ GREATER GREATEROREQ PLUS MINUS MULT SLASH AND OR NEG STR_OP ID ASSIGN FLOAT NR LB RB EVAL PRINT

%type <valINT> NR
%type <valFLOAT> FLOAT
%type <valSTRING> ID STRING TYPE
%start program

%right ASSIGN
%left '+' '-'
%left '*' '/'
%left '<' '>' '<=' '>='
%left '||'
%left '&&'
%left '!'
%%
program: declaratii bloc {printf("program corect sintactic\n");}
     ;

declaratii :  declaratie ';'
	   | declaratii declaratie ';'
	   ;
declaratie : TYPE ID 
          {
			strcpy(variabila,$2);
               strcpy(tip,$1);
			if (cauta(variabila,nr_globale,var_globale) == -1) {
					strcpy(var_globale[nr_globale],variabila);
					nr_globale++;
					addvariabila(var,tip,"global",-1);
			}
			else   
				yyerror("Variabila deja declarata!");	   
		}
           ;
/* bloc */
bloc : BGIN list END  
     ;
     
/* lista instructiuni */
list :  statement ';' 
     | list statement ';'
     ;

/* instructiune */
statement: ID ASSIGN ID
         | ID ASSIGN NR  		 
         | ID '(' lista_apel ')'
         ;
        
lista_apel : NR
           | lista_apel ',' NR
           ;
%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}
void addvariabila(char* nume, char *tip, char* tip2, int val) {
	FILE *fptr;
	fptr = fopen("symbol_table.txt", "a+");
	strcpy(obj.nume,nume);
	strcpy(obj.type, tip);
	strcpy(obj.scope, scop);
	obj.valoareVar = val;
	if (val == -1)
		fprintf(fptr,"\nNUME %s - TIP %s - SCOPE %s - NU ARE INCA VALOARE\n", obiect.nume, obiect.type, obiect.scope); 
	close(fptr);
}
int cauta(char *name, int n, char v[][100]) {
	int ok = 0;
	for (int i=0;i<=n;i++)
		if (strcmp(vector[i],nume)==0)
			found=1;
	 if (found ==0) return -1;
		else return 1;
}
int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 