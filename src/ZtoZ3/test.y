%{
#include <stdio.h>
#include <string.h>
#include "lex.yy.c"
int yydebug = 1;
%}

%start schema


%token  STRING	VARIABLE TYPE 
%token  NUMBER  
%token  G GE L LE E NE SEMICOLON COLON COMMA LBRACKET RBRACKET AND OR ADD SUB MUL DIV

%right E NE

%left  OR
%left  AND

%left ADD SUB
%left MUL DIV


%%

schema	:  schemaname SEMICOLON declaration SEMICOLON formula SEMICOLON 
				  {
						printf("(assert %s)\n", $5);
						printf("(apply (then simplify (repeat (or-else split-clause skip)))) \n //accept!\n");
				  }
        |  schema schemaname SEMICOLON declaration SEMICOLON formula SEMICOLON 
		          {
						printf("(assert %s)\n", $6);
						printf("(apply (then simplify (repeat (or-else split-clause skip)))) \n //accept!\n");
				  }
	    ;
		
schemaname	:	STRING 
				{
					printf("schemaname is: %s\n",$1);
				}
	        ;
		   
declaration 	:   VARIABLE COLON TYPE 
                    { printf("(declare-const %s %s)\n", $1, $3);}  
				| 	declaration COMMA VARIABLE COLON TYPE
				    { printf("(declare-const %s %s)\n", $3, $5);}  
				;
		   
formula		:	predicate 
			|   LBRACKET formula RBRACKET
						{
							char str[50];
							sprintf(str,"%s%s%s","(",$2,")");
							$$ = str;
					    }
			|   formula AND formula
					    {
							char ssss[50];
							sprintf(ssss,"%.5s%.10s%.1s%.1s%.1s","(and ",$1," ",$3,")");
							printf("--result: %s----%s And %s------", ssss, $1, $3);
							$$ = ssss;
					    }		
			|   formula OR formula
					    {
							char ssss[50];
							sprintf(ssss,"%s%s%s%s%s","(or ",$1," ",$3,")");
							printf("--result: %s----%s OR %s------", ssss, $1, $3);
							$$ = ssss;
					    }		
			;

predicate 	:   expr  G  expr				
                      {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(> ",$1," ",$3,")");
						  $$ = str;
					  }		
			|   expr  GE  expr	
					  {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(>= ",$1," ",$3,")");
						//	  printf("great equal is %s", str);
						  $$ = str;
					  }					
			|   expr  L  expr		
					  {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(< ",$1," ",$3,")");
						//  printf("less is %s", str);
						  $$ = str;
					  }		
			|   expr  LE  expr	
					  {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(<= ",$1," ",$3,")");
						//  printf("less equal is %s", str);
						  $$ = str;
					  }				
			|   expr  E  expr	
                      {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(= ",$1," ",$3,")");
						//  printf("equal is %s 1: %s 2: %s", str, $1, $3);
						  $$ = str;
						  
					  }				
			|   expr  NE  expr		
					  {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(not (= ",$1," ",$3,"))");
						//  printf("not equal is %s", str);
						  $$ = str;
					  }	
			;
			
expr	:	NUMBER 						
	    |   VARIABLE 						
        |   LBRACKET  expr  RBRACKET
					  {
							char str[50];
							sprintf(str,"%s%s%s","(",$2,")");
							$$ = str;
					  }
	    |   expr ADD expr 		
				      {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(+ ",$1," ",$3,")");
						  $$ = str;
					  }				
		|   expr SUB expr			
				      {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(- ",$1," ",$3,")");
						  $$ = str;
					  }				
		|   expr MUL expr		
					  {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(* ",$1," ",$3,")");
						  $$ = str;
					  }				
		|   expr DIV expr			
					  {
						  char str[20];
						  sprintf(str,"%s%s%s%s%s","(/ ",$1," ",$3,")");
						  $$ = str;
					  }				
		;
%% 

int yywrap()
{
    return 1;
}

int yyerror(char *str)  
{  
    fprintf(stderr,"Error: %s\n",str);  
    return 1;        
}

int main()
{
    yyparse();
	return 0;
}