%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "lex.yy.c"
int yydebug = 1;
%}

%start schema

%union
{
    char string[2000];
}

%token  <string> STRING	 VARIABLE  TYPE 
%token  <string> NUMBER  
%token  G GE L LE E NE SEMICOLON COLON COMMA LBRACKET RBRACKET AND OR ADD SUB MUL DIV

%right E NE

%left  OR
%left  AND

%left ADD SUB
%left MUL DIV

%type <string> formula predicate expr

%%

schema	:  schemaname SEMICOLON declaration SEMICOLON formula SEMICOLON 
				  {
						fprintf(yyout, "(assert %s)\n", $5);
						fprintf(yyout, "(apply (then simplify (repeat (or-else split-clause skip)))) \n");
						printf("accept\n");
				  }
        |  schema schemaname SEMICOLON declaration SEMICOLON formula SEMICOLON 
		          {
						fprintf(yyout, "(assert %s)\n", $6);
						fprintf(yyout, "(apply (then simplify (repeat (or-else split-clause skip)))) \n");
						printf("accept\n");
				  }
	    ;
		
schemaname	:	STRING 
				{
					printf("schemaname is: %s\n",$1);
				}
	        ;
		   
declaration 	:   VARIABLE COLON TYPE 
                    { fprintf(yyout, "(declare-const %s %s)\n", $1, $3);}  
				| 	declaration COMMA VARIABLE COLON TYPE
				    { fprintf(yyout, "(declare-const %s %s)\n", $3, $5);}  
				;
		   
formula		:	predicate 
			|   LBRACKET formula RBRACKET
						{
							strcpy($$,$2);
					    }
			|   formula AND formula
					    {
							char ssss[500];
							sprintf(ssss,"%s%s%s%s%s","(and ",$1," ",$3,")");
							printf("--result: %s----%s And %s------", ssss, $1, $3);
							//$$ = ssss;
							strcpy($$,ssss);
					    }		
			|   formula OR formula
					    {
							char ssss[500];
							sprintf(ssss,"%s%s%s%s%s","(or ",$1," ",$3,")");
							printf("--result: %s----%s OR %s------", ssss, $1, $3);
							strcpy($$,ssss);
					    }		
			;

predicate 	:   expr  G  expr				
                      {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(> ",$1," ",$3,")");
						  strcpy($$,str);
					  }		
			|   expr  GE  expr	
					  {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(>= ",$1," ",$3,")");
						//	  printf("great equal is %s", str);
						  strcpy($$,str);
					  }					
			|   expr  L  expr		
					  {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(< ",$1," ",$3,")");
						//  printf("less is %s", str);
						  strcpy($$,str);
					  }		
			|   expr  LE  expr	
					  {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(<= ",$1," ",$3,")");
						//  printf("less equal is %s", str);
						  strcpy($$,str);
					  }				
			|   expr  E  expr	
                      {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(= ",$1," ",$3,")");
						//  printf("equal is %s 1: %s 2: %s", str, $1, $3);
						  strcpy($$,str);
						  
					  }				
			|   expr  NE  expr		
					  {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(not (= ",$1," ",$3,"))");
						//  printf("not equal is %s", str);
						  strcpy($$,str);
					  }	
			;
			
expr	:	NUMBER 						
	    |   VARIABLE 						
        |   LBRACKET  expr  RBRACKET
					  {
						  strcpy($$,$2);
					  }
	    |   expr ADD expr 		
				      {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(+ ",$1," ",$3,")");
						  strcpy($$,str);
					  }				
		|   expr SUB expr			
				      {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(- ",$1," ",$3,")");
						  strcpy($$,str);
					  }				
		|   expr MUL expr		
					  {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(* ",$1," ",$3,")");
						  strcpy($$,str);
					  }				
		|   expr DIV expr			
					  {
						  char str[200];
						  sprintf(str,"%s%s%s%s%s","(/ ",$1," ",$3,")");
						  strcpy($$,str);
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

void main(int argc, char *argv[])
{
	//prompt for use
    if (argc == 1)
	{  
	    printf("ZtoZ3 is a compile which transform Z notation to Z3\n");
	    printf("Usage: ZtoZ3 SourceFile TargetFile\n");
	}
	else
	{
		//open file and write result to file
		int size;
		char *buff;
		FILE *fp;
		fp = fopen(argv[1], "r");
		yyout = fopen(argv[2], "w");
		if (fp == NULL)
		{
			printf("fail to open!\n");
		}
		else
		{
			yyin = fp;
		}
		
		//parse file
		yyparse();
		fclose(yyin);
		fclose(yyout);
	}
}