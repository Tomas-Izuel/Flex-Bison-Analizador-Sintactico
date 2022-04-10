bison -d sintactico.y
flex lexico.l
gcc -o analizador sintactico.tab.c lex.yy.c -lm