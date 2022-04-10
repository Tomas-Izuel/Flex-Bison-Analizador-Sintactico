%{
	
#include <stdio.h> 
#include <string.h>
#include "sintactico.tab.h"
extern char *Lexema[100], *Token[100];
extern int SubIndice, SubIndiceMax, NumLineas;


int CargarSubCadenas(char* NomToken);

%}

%option noyywrap

%%  

	
"ALPHABET_NAME"             			{printf("\n Lectura de Token: ALPHABET-NAME \n");
						CargarSubCadenas("ALPHNAME");return (ALPHNAME);}	

"SYMBOLIC"        				{printf("\n Lectura de Token: SYMBOLIC-CHARACTERS-CLAUSE \n");
						CargarSubCadenas("SYMB"); return (SYMB);}
	
"CLASS_CLAUSE"            		 	{printf("\n Lectura de Token: CLASS-CLAUSE \n");
						CargarSubCadenas("CLASS"); return (CLASS);}

"LITERAL"            				{printf("\n Lectura de Token: LITERAL \n");
						CargarSubCadenas("LIT"); return (LIT);} 
	
"IS"           					{printf("\n Lectura de Token: IS \n");
						CargarSubCadenas("ISS"); return (ISS);}

"ALPHABET"       				{printf("\n Lectura de Token: ALPHABET \n");
						CargarSubCadenas("ALPH"); return (ALPH);}
	
"STANDARD1"     				{printf("\n Lectura de Token: STANDARD-1 \n");
						CargarSubCadenas("STAND1"); return (STAND1);}

"STANDARD2"         				{printf("\n Lectura de Token: STANDARD-2 \n");
						CargarSubCadenas("STAND2"); return (STAND2);}
	
"NATIVE"       					{printf("\n Lectura de Token: NATIVE \n");
						CargarSubCadenas("NAT"); return (NAT);}

"EBCDIC"           				{printf("\n Lectura de Token: EBCDIC \n");
						CargarSubCadenas("EB"); return (EB);}
	
"CURRENCY"           				{printf("\n Lectura de Token: CURRENCY \n ");
						CargarSubCadenas("CURR"); return (CURR);}	

"SIGN"           				{printf("\n Lectura de Token: SIGN \n");
						CargarSubCadenas("SIG"); return (SIG);}


\n {
	SubIndiceMax=SubIndice;
	SubIndice=0;
	NumLineas++;
	return (NL);}

%%

int CargarSubCadenas(char* NomToken){
	Lexema[SubIndice]=(char*)malloc((strlen(yytext)+1)*sizeof(char));
	strcpy(Lexema[SubIndice],yytext);
	Token[SubIndice]=(char*)malloc((strlen(NomToken)+1)*sizeof(char));
	strcpy(Token[SubIndice],NomToken);
	SubIndice++;
	return 0;
}