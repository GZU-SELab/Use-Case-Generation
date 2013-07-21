%{
#include <stdio.h>
#include <string.h>
#include "lex.yy.c"
%}

%start schema


%token  STRING	VARIABLE TYPE 
%token  NUMBER  
%token  G GE L LE E NE SEMICOLON COLON COMMA LBRACKET RBRACKET AND OR ADD SUB MUL DIV

%right E NE

%left AND OR

%left ADD SUB
%left MUL DIV


%%

schema	:  schemaname SEMICOLON declaration SEMICOLON formula SEMICOLON  {printf("(apply (then simplify (repeat (or-else split-clause skip)))) \n //accept!\n");}
        |  schema schemaname SEMICOLON declaration SEMICOLON formula SEMICOLON {printf("(apply (then simplify (repeat (or-else split-clause skip)))) \n //accept!\n");}
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
		   
formula		:	predicate {printf("(assert %s)\n", $1)}
			|   LBRACKET formula RBRACKET
			|   formula AND formula
			|   formula OR formula
			;

predicate 	:   expr  G  expr				
                      {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(> ",$1," ",$3,")");
						  $$ = ss;
					  }		
			|   expr  GE  expr	
					  {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(>= ",$1," ",$3,")");
						  $$ = ss;
					  }					
			|   expr  L  expr		
					  {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(< ",$1," ",$3,")");
						  $$ = ss;
					  }		
			|   expr  LE  expr	
					  {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(<= ",$1," ",$3,")");
						  $$ = ss;
					  }				
			|   expr  E  expr	
                      {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(= ",$1," ",$3,")");
						  $$ = ss;
					  }				
			|   expr  NE  expr		
					  {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(!= ",$1," ",$3,")");
						  $$ = ss;
					  }	
			;
			
expr	:	NUMBER 						
	    |   VARIABLE 						
        |   LBRACKET  expr  RBRACKET
	    |   expr ADD expr 		
				      {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(+ ",$1," ",$3,")");
						  $$ = ss;
					  }				
		|   expr SUB expr			
				      {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(- ",$1," ",$3,")");
						  $$ = ss;
					  }				
		|   expr MUL expr		
					  {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(* ",$1," ",$3,")");
						  $$ = ss;
					  }				
		|   expr DIV expr			
					  {
						  char *ss;
						  sprintf(ss,"%s%s%s%s%s","(/ ",$1," ",$3,")");
						  $$ = ss;
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