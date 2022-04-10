%{
#include <stdio.h>
#include <windows.h>
#include <stdlib.h>
#include <string.h>
int Dibujar=0, Recursion=0,MaxRecursion;

char *Lexema[100], *Token[100];

int SubIndice=0, SubIndiceMax, NumLineas=1, EstadoScanner=0, NumDer, SubTipo, op1=0, op2=0, varias=0, aument1 = 0, aument2 = 0;

extern char* yytext;
extern FILE *yyin;

int yyerror(char *s);
int yylex();

int Derivaciones();
int DibujarTablaDeTokens();
int ArbolDeDerivacion();

%}


%token ALPHNAME SYMB CLASS LIT ISS ALPH STAND1 STAND2 NAT EB CURR SIG NL 

%start axioma

%%
axioma: alphabet_clause NL	              {printf("\n CADENA VALIDA \n"); Derivaciones(1);DibujarTablaDeTokens();ArbolDeDerivacion(1);op1=0;op2=0;varias=0;printf("\n\nINGRESE UNA CADENA: "); yyparse();}          			
	|special_names_paragraph_clauses NL   {printf("\n CADENA VALIDA \n"); Derivaciones(2);DibujarTablaDeTokens();ArbolDeDerivacion(2);op1=0;op2=0;varias=0;printf("\n\nINGRESE UNA CADENA: ") ;yyparse();}           		
	|currency_sign_clause NL      	      {printf("\n CADENA VALIDA \n"); Derivaciones(3);DibujarTablaDeTokens();ArbolDeDerivacion(3);op1=0;op2=0;varias=0;printf("\n\nINGRESE UNA CADENA: ") ; yyparse();}
	|alphabet_clause_error        	      {yyerrok;}
	|currency_sign_clause_error	      {yyerrok;}
	|error NL			      {yyerrok; printf("\n\nINGRESE UNA CADENA: ");yyparse();}
	|NL        			      {printf("\n CADENA VALIDA \n"); printf("\n\nINGRESE UNA CADENA: "); yyparse();}
	;
	
alphabet_clause: ALPH alphabet_name op1 seg
	       ;                             

alphabet_name: ALPHNAME
	     ;	                              

op1: ISS                                      	       {op1 = 1;}                                                                            
     |
     ;
							
seg : STAND1                                           {varias = 1;}                                      
      |STAND2                                          {varias = 2;}
      |NAT                                             {varias = 3;} 
      |EB 					       {varias = 4;}
      ;

alphabet_clause_error:alphabet_name op1 seg            {yyerrok; printf("\n\n ERROR LEXICO: Falta terminal 'ALPHABET' \n\n");yyparse();}
	             |ALPH alphabet_name op1           {yyerrok; printf("\n\n ERROR LEXICO: Falta terminal 'STANDARD1|STANDARD1|NATIVE|EBCDIC' \n\n");yyparse();}
		     |ALPH op1 seg                     {yyerrok; printf("\n\n ERROR LEXICO: Falta terminal 'ALPHABET_NAME' \n\n");yyparse();}
                     ;
	

													
special_names_paragraph_clauses: aux1                  {varias = 5;}             
				|aux2                  {varias = 6;}
	                        ;

aux1: symbolic_characters_clause                    
      |aux1 symbolic_characters_clause
      ;              	

symbolic_characters_clause: SYMB                   	{aument1++;}
                           ;

aux2: class_clause                                  
      |aux2 class_clause
      ;                            

class_clause: CLASS                                     {aument2++;}
             ; 
			
currency_sign_clause: CURR op2 op1 literal
                    ;              

currency_sign_clause_error:op2 op1 literal             	{yyerrok; printf("\n\n ERROR LEXICO: Falta terminal 'CURRENCY' \n\n");yyparse();}
			  |CURR op2 op1 		{yyerrok; printf("\n\n ERROR LEXICO: Falta terminal 'LITERAL' \n\n");yyparse();}
                          ;
	   
op2: SIG                                                {op2 = 1;}
     | 
     ;                                           

literal: LIT
       ;

%%

/* Rutina de error */
int yyerror (char *msg) {
         if(EstadoScanner==1){	 
         printf("\n Error en la linea %d \n", NumLineas);}
	 printf("\n CADENA INVALIDA: %s ***\n ", msg);
	       
}

/* La llamada a la accion principal */
FILE *yyin;

int main(int argc, char *argv[])
           {
           FILE *ArchEnt;
           if (argc == 2)
                {
                 ArchEnt=fopen(argv[1], "rt");
                 if (!ArchEnt) {
                           fprintf(stderr, "No se encuentra el archivo %s \n", argv[1]);
                           exit(1);
           }
           yyin=ArchEnt;
           EstadoScanner=1;
           }
	   printf("\nINGRESE UNA CADENA: ");                                                      
           yyparse();                                                      
           return 0;
}                                

/* Llamada a funcion de finalizacion */
int yywrap() { 
        EstadoScanner=2;
	printf("Finalizacion de analisis\n");
	return 1;
}

int Derivaciones(int NumDer) {

	printf("\n  ------------------------------ DERIVACIONES -------------------------------  \n");

	switch (NumDer) {

	case 1: 
	printf("\n axioma --> alphabet_clause \n");
	printf("\n alphabet_clause --> ALPH alphabet_name op1 seg \n");
	printf("\n alphabet_name --> ALPHNAME \n");
		if(op1==1){
			printf("\n op1 --> ISS \n");
	}

		if(varias==1){
			printf("\n seg --> STAND1 \n");
	}

		if(varias==2){
			printf("\n seg --> STAND2 \n");
	}

		if(varias==3){
			printf("\n seg --> NAT \n");
	}

		if(varias==4){
			printf("\n seg --> EB \n");
	}
	break;

	case 2: 
	printf("\n axioma --> special_names_paragraph_clauses \n");
	printf("\n special_names_paragraph_clauses: aux1 | aux2 \n"); 
		if(varias == 5){
			printf("\n aux1 --> symbolic_characters_clause | aux1 symbolic_characters_clause \n"); 
			printf("\n symbolic_characters_clause: SYMB \n"); 
	}
		if(varias == 6){
			printf("\n aux2 --> class_clause | aux2 class_clause \n"); 
			printf("\n class_clause: CLASS \n"); 
	}              
	break;

	case 3:
	printf("\n axioma --> currency_sign_clause \n");
	printf("\n currency_sign_clause --> CURR op2 op1 literal \n");
		if(op1==1){
			printf("\n op1 --> ISS \n");
	}
		if(op2==1){
			printf("\n op2 --> SIG \n");
	}
	printf("\n literal --> LIT \n");
	break;

	default: 
	break;
	}

	return (0) ;
}

/* Llamada a función que dibuja la tabla */

int DibujarTablaDeTokens(){
	int ContAuxT,ContAuxK;
	int LargoToken,LargoIzq,LargoDer;

	printf("\n===============================TABLA DE SIMBOLOS===============================\n");
	printf("|                LEXEMAS               |                 TOKENS               |\n");
	printf("---------------------------------------+---------------------------------------\n");

	for (ContAuxK=0;ContAuxK<SubIndiceMax;ContAuxK++){
		LargoToken=38-strlen(Lexema[ContAuxK]);
		if ((LargoToken & 1)==0){
			LargoIzq=LargoToken/2;
		}else{
			LargoIzq=(LargoToken+1)/2;
		}
		LargoDer=LargoToken-LargoIzq;
		printf("|");
		for (ContAuxT=0;ContAuxT<LargoIzq;ContAuxT++){
			printf(" ");
		}
		printf("%s",Lexema[ContAuxK]);
		for (ContAuxT=0;ContAuxT<LargoDer;ContAuxT++){
			printf(" ");
		}
		printf("|");
	
		LargoToken=38-strlen(Token[ContAuxK]);
		if ((LargoToken & 1)==0){
			LargoIzq=LargoToken/2;
		}else{
			LargoIzq=(LargoToken+1)/2;
		}
		LargoDer=LargoToken-LargoIzq;
		for (ContAuxT=0;ContAuxT<LargoIzq;ContAuxT++){
			printf(" ");
		}
		printf("%s",Token[ContAuxK]);
		for (ContAuxT=0;ContAuxT<LargoDer;ContAuxT++){
			printf(" ");
		}
		printf("|\n");
	}
	printf("===============================================================================\n\n\n");
	return 0;
}

/* Llamada a función que dibuja el árbol */

int ArbolDeDerivacion(int SubTipo){

	printf("\n ----------------------------ARBOL DE DERIVACION---------------------------- \n");
        printf("\n                                   axioma                                    \n");
        printf("\n                                     |                                       \n");

	switch(SubTipo){

	case 1: 
	printf("\n                              alphabet_clause                                \n");

	if(op1==1 && varias==1){

	printf("\n                                     |                                       \n");
	printf("\n                      ---------------+--------------------------------       \n");
	printf("\n                     |               |               |               |       \n");
	printf("\n                 ALPHABET     alphabet_name         op2             seg      \n");
	printf("\n                                     |               |               |       \n");
	printf("\n                                     +--------------------------------       \n");
	printf("\n                                     |               |               |       \n");
	printf("\n                    	        ALPHABET_NAME	      ISS          STANDARD1   \n");
	}

	else{
		if(varias==1){

	printf("\n                                      |                                       \n");
	printf("\n                      ----------------+----------------                       \n");
	printf("\n                      |               |               |                       \n");
	printf("\n                  ALPHABET     alphabet_name         seg                      \n");
	printf("\n                                      |               |                       \n");
	printf("\n                                      +----------------                       \n");
	printf("\n                                      |               |                       \n");
	printf("\n                    	         ALPHABET_NAME	     STANDARD1                  \n");
		}
	}
	
	if(op1==1 && varias==2){

	printf("\n                                      |                                       \n");
	printf("\n                      ----------------+--------------------------------       \n");
	printf("\n                      |               |               |               |       \n");
	printf("\n                  ALPHABET     alphabet_name         op2             seg      \n");
	printf("\n                                      |               |               |       \n");
	printf("\n                                      +--------------------------------       \n");
	printf("\n                                      |               |               |       \n");
	printf("\n                    	         ALPHABET_NAME	       ISS         STANDARD2    \n");
	}
	else{
		if(varias==2){
	printf("\n                                      |                                       \n");
	printf("\n                      ----------------+----------------                       \n");
	printf("\n                      |               |               |                       \n");
	printf("\n                  ALPHABET     alphabet_name         seg                      \n");
	printf("\n                                      |               |                       \n");
	printf("\n                                      +----------------                       \n");
	printf("\n                                      |               |                       \n");
	printf("\n                    		ALPHABET_NAME	     STANDARD2                  \n");
		}
	}
	
	if(op1==1 && varias==3){

	printf("                                      |                                         ");
	printf("                      ----------------+--------------------------------         ");
	printf("                      |               |               |               |         ");
	printf("                  ALPHABET     alphabet_name         op2             seg        ");
	printf("                                      |               |               |         ");
	printf("                                      +--------------------------------         ");
	printf("                                      |               |               |         ");
	printf("                    	      ALPHABET_NAME	     ISS           NATIVE       ");
	}
	else{
		if(varias==3){

	printf("\n                                      |                                       \n");
	printf("\n                      ----------------+----------------                       \n");
	printf("\n                      |               |               |                       \n");
	printf("\n                  ALPHABET     alphabet_name         seg                      \n");
	printf("\n                                      |               |                       \n");
	printf("\n                                      +----------------                       \n");
	printf("\n                                      |               |                       \n");
	printf("\n                    		 ALPHABET_NAME	      NATIVE                    \n");
		}
	}

	if(op1==1 && varias==4){

	printf("\n                                      |                                       \n");
	printf("\n                      ----------------+--------------------------------       \n");
	printf("\n                      |               |               |               |       \n");
	printf("\n                  ALPHABET     alphabet_name         op2             seg      \n");
	printf("\n                                      |               |               |       \n");
	printf("\n                                      +--------------------------------       \n");
	printf("\n                                      |               |               |       \n");
	printf("\n                    		 ALPHABET_NAME	       ISS           EBCDIC     \n");
	}
	else{
		if(varias==4){

	printf("\n                                      |                                       \n");
	printf("\n                      ----------------+----------------                       \n");
	printf("\n                      |               |               |                       \n");
	printf("\n                  ALPHABET     alphabet_name         seg                      \n");
	printf("\n                                      |               |                       \n");
	printf("\n                                      +----------------                       \n");
	printf("\n                                      |               |                       \n");
	printf("\n                    		 ALPHABET_NAME	      EBCDIC                    \n");
		}
	}
	break;
	
	case 2: 
	printf("\n                          special_names_paragraph_clauses                     \n");
	printf("\n                                        |                                     \n");
	
 	if(varias==5){
	printf("\n                                        |                                     \n");
	printf("\n                                       aux1                                   \n");
	do{
		aument1= aument1 - 1;
	
	printf("\n                                        |                                     \n");
	printf("\n                                     SYMBOLIC                                 \n");
	
			
	}while(aument1!=0);

	}

	if(varias==6){
	printf("\n                                        |                                     \n");
	printf("\n                                       aux2                                   \n");
	do{
		aument2= aument2 - 1;
	
	printf("\n                                        |                                     \n");
	printf("\n                                      CLASS                                   \n");
	
			
	}while(aument2!=0);

	}
	break;

	case 3: 
	printf("\n                          special_names_paragraph_clauses                     \n");
	
	if(op1==1 && op2==1){

	printf("\n                                        |                                     \n");
	printf("\n                        ----------------+--------------------------------     \n");
	printf("\n                        |               |               |               |     \n");
	printf("\n                    CURRENCY     	 op2             op1           LITERAL  \n");
	printf("\n                                        |               |                     \n");
	printf("\n                                        +---------------+                     \n");
	printf("\n                                        |               |                     \n");
	printf("\n                    			 SIGN	         ISS                    \n");
	}
	else{
		if(op2==1){

	printf("\n                                        |                                     \n");
	printf("\n                        ----------------+----------------                     \n");
	printf("\n                        |               |               |                     \n");
	printf("\n                    CURRENCY     	 op2             LITERAL                \n");
	printf("\n                                        |                                     \n");
	printf("\n                                        +                                     \n");
	printf("\n                                        |                                     \n");
	printf("\n                    			 SIGN	                                \n");
	}
	}
	
	if(op1==1){

	printf("\n                                        |                                     \n");
	printf("\n                        ----------------+----------------                     \n");
	printf("\n                        |               |               |                     \n");
	printf("\n                    CURRENCY     	 op2             LITERAL                \n");
	printf("\n                                        |                                     \n");
	printf("\n                                        +                                     \n");
	printf("\n                                        |                                     \n");
	printf("\n                    			 ISS	                                \n");
	}

	if(op1==0 && op2==0){

	printf("\n                                        |                                     \n");
	printf("\n                        ----------------+----------------                     \n");
	printf("\n                        |                               |                     \n");
	printf("\n                    CURRENCY     	              LITERAL                   \n");
	}
	
	break;
	}

	return(0);
}

