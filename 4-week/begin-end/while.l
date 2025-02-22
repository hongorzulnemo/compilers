%option noyywrap c++ yylineno

%{
#include <iostream>
#include <stdlib.h>
#include "Parserbase.h"
%}

DIGIT  		[0-9]
WS          [ \t\n]
LETTER      [a-zA-Z]

%%

program     return Parser::T_PROGRAM;
begin       return Parser::T_BEGIN;
end         return Parser::T_END;
integer     return Parser::T_INTEGER; 
boolean     return Parser::T_BOOLEAN;
skip        return Parser::T_SKIP;
if          return Parser::T_IF;
else        return Parser::T_ELSE;
while       return Parser::T_WHILE;
read        return Parser::T_READ;
write       return Parser::T_WRITE;
";"         return Parser::T_SEMICOLON;
":="        return Parser::T_ASSIGN;
"="         return Parser::T_EQ;
"<"         return Parser::T_LESS;
">"         return Parser::T_GR;
"+"         return Parser::T_ADD;
"-"         return Parser::T_SUB;
"*"         return Parser::T_MUL;
and         return Parser::T_AND;
or          return Parser::T_OR;
not         return Parser::T_NOT;
div         return Parser::T_DIV; 
mod         return Parser::T_MOD;
"("         return Parser::T_OPEN;
")"         return Parser::T_CLOSE;

{DIGIT}+	return Parser::T_NUM;
true        return Parser::T_TRUE;
false       return Parser::T_FALSE;

"#".*\n    // nothing to do

{LETTER}({LETTER}|{DIGIT}|_)*    return Parser::T_ID;

{WS}+   // nothing to do

. {
    std::cerr << "Line " << lineno() << ": Lexical error." << std::endl;
    exit(1);
}

%%
