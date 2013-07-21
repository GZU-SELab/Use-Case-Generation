%{
#include <stdio.h>
#include "y.tab.h"
%}

type		Int
string		[a-zA-Z_][0-9a-zA-Z_-]*
variable	[a-zA-Z_][0-9a-zA-Z_-]*[?!]
number		[0-9]+ 
predicate   ">"|">="|"<"|"<="|"=="|"!="
connector   "&&"|"||"
opt 		"+"|"-"|"*"|"/"
others		";"|":"|","|"("|")"
%%

{type}            				  {printf("read type: %s\n", yytext); yylval = strdup(yytext); return TYPE;}
{string}           				  {printf("read string: %s\n", yytext); yylval = strdup(yytext); return STRING;}
{variable}     				      {printf("read variable: %s\n", yytext);yylval = strdup(yytext); return VARIABLE;}
{number}    				      {printf("read number: %s\n", yytext);yylval = strdup(yytext); return NUMBER;}
{predicate}						  {
										switch(yytext[0])
										{
											case '>':
											    if (yyleng > 1)
												{
													printf("read >=\n");
													return GE;
												}
												else
												{
													printf("read >\n");
												    return G;
												}
												break;
											case '<':
												if (yyleng > 1)
												{
													printf("read <=\n");
													return LE;
												}
												else
												{
													printf("read <\n");
												    return L;
												}
												break;	
											case '=':
												    return E;
												break;	
											case '!':
												    return NE;
												break;													
										}
								  }
{connector}						  {
										switch(yytext[0])
										{
											case '&':
												return AND;
												break;
											case '|':
												return OR;
												break;									
										}
								  }
{opt}						      {  
										switch(yytext[0])
										{
											case '+':
												return ADD;
												break;
											case '-':
												return SUB;
												break;
											case '*':
												return MUL;
												break;
											case '/':
												return DIV;
												break;
										}
								  }								  
{others}						  {
										switch(yytext[0])
										{
											case ';':
											    printf("read SEMICOLON\n");
												return SEMICOLON;
												break;
											case ':':
												printf("read COLON\n");
												return COLON;
												break;
											case ',':
												printf("read COMMA\n");
												return COMMA;
												break;
											case '(':
											    printf("read LBRACKET\n");
												return LBRACKET;
												break;
											case ')':
                                                printf("read RBRACKET\n");											
												return RBRACKET;
												break;
										}
								  }
								  
							
[ \t\r\n]+        				  {ECHO; /* ignore blank */}

%%
