%{
#include <stdio.h>
#include <string.h>
#include "lex.yy.c"

int yywrap()
{
    return 1;
}

int main()
{
    yyparse();
}

int yyerror(char *str)  
{  
    fprintf(stderr,"Error: %s\n",str);  
    return 1;        
}


%}

%token  NUMBER TOKHEAT STATE TOKTARGET TOKTEMPERATURE

%%

commands: /* empty */
    | commands command
;

command: heat_switch
    | target_set
;

heat_switch:
    TOKHEAT STATE
    {
        printf("\tHeat turned on or off\n");
    }
;

target_set:
    TOKTARGET TOKTEMPERATURE NUMBER
    {
        printf("\tTemperature set\n");
    }
;

