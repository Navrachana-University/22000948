%{
#include "yacc.tab.h"
%}
%option noyywrap

%%

"banav"        { return BANAV; }
"maate"        { return MAATE; }
"nahito"       { return NAHITO; }
"jyasudhi"     { return JYASUDHI; }
"pheravo"      { return PHERAVO; }
"chhodo"       { return CHHODO; }
"chaluvado"    { return CHALUVADO; }
"chhapo"       { return CHHAPO; }

[0-9]+         { yylval.str = strdup(yytext); return NUMBER; }
\"[^\"]*\"     { yylval.str = strdup(yytext); return STRING; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }

[ \t\n]+       { /* skip whitespace */ }
.              { return yytext[0]; }

%%   <-- VERY IMPORTANT (you missed this)