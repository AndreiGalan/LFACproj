all: 
	yacc -d limbaj.y 
	lex  limbaj.l
	gcc lex.yy.c  y.tab.c -o limbaj

clean:
	rm -f y.tab.c y.tab.h lex.yy.c limbaj
