%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int label_count = 0;
char temp_var[10][20];
int temp_index = 0;

char* new_label() {
    label_count++;
    static char label[20];
    sprintf(label, "L%d", label_count);
    return label;
}

char* new_temp_var() {
    static char temp[20];
    sprintf(temp, "t%d", temp_index++);
    return temp;
}

FILE *output_file;
extern FILE *yyin;

int yylex();
int yyerror(char *s);
%}

/* YYSTYPE now carries string (char*) values */
%union {
    char *str;
}

/* Tokens */
%token <str> IDENTIFIER NUMBER STRING
%token BANAV MAATE NAHITO JYASUDHI PHERAVO CHHODO CHALUVADO CHHAPO

/* Types for nonterminals */
%type <str> expression

%left '+' '-'
%left '*' '/'
%left '<' '>'
%left '='
%right UMINUS

%%

program:
    statement_list
;

statement_list:
    statement statement_list
    | /* empty */
;

statement:
    variable_declaration
    | assignment
    | if_statement
    | while_loop
    | return_statement
    | break_statement
    | continue_statement
    | print_statement
;

variable_declaration:
    BANAV IDENTIFIER '=' expression ';'
    {
        fprintf(output_file, "%s = %s\n", $2, $4);
    }
;

assignment:
    IDENTIFIER '=' expression ';'
    {
        fprintf(output_file, "%s = %s\n", $1, $3);
    }
;

if_statement:
    MAATE expression '{' statement_list '}' NAHITO '{' statement_list '}'
    {
        char *label1 = new_label();
        char *label2 = new_label();
        char *label3 = new_label();
        fprintf(output_file, "if %s goto %s\n", $2, label1);
        fprintf(output_file, "goto %s\n", label2);
        fprintf(output_file, "%s:\n", label1);
        // True branch
        fprintf(output_file, "goto %s\n", label3);
        fprintf(output_file, "%s:\n", label2);
        // False branch
        fprintf(output_file, "%s:\n", label3);
    }
;

while_loop:
    JYASUDHI expression '{' statement_list '}'
    {
        char *start = new_label();
        char *end = new_label();
        fprintf(output_file, "%s:\n", start);
        fprintf(output_file, "if not %s goto %s\n", $2, end);
        // Loop body
        fprintf(output_file, "goto %s\n", start);
        fprintf(output_file, "%s:\n", end);
    }
;

return_statement:
    PHERAVO expression ';'
    {
        fprintf(output_file, "return %s\n", $2);
    }
;

break_statement:
    CHHODO ';'
    {
        char *label = new_label();
        fprintf(output_file, "goto %s\n", label);
    }
;

continue_statement:
    CHALUVADO ';'
    {
        char *label = new_label();
        fprintf(output_file, "goto %s\n", label);
    }
;

print_statement:
    CHHAPO expression ';'
    {
        fprintf(output_file, "print %s\n", $2);
    }
;

expression:
    NUMBER
    {
        $$ = strdup($1);
    }
    | STRING
    {
        $$ = strdup($1);
    }
    | IDENTIFIER
    {
        $$ = strdup($1);
    }
    | expression '+' expression
    {
        char *temp = new_temp_var();
        fprintf(output_file, "%s = %s + %s\n", temp, $1, $3);
        $$ = strdup(temp);
    }
    | expression '-' expression
    {
        char *temp = new_temp_var();
        fprintf(output_file, "%s = %s - %s\n", temp, $1, $3);
        $$ = strdup(temp);
    }
    | expression '*' expression
    {
        char *temp = new_temp_var();
        fprintf(output_file, "%s = %s * %s\n", temp, $1, $3);
        $$ = strdup(temp);
    }
    | expression '/' expression
    {
        char *temp = new_temp_var();
        fprintf(output_file, "%s = %s / %s\n", temp, $1, $3);
        $$ = strdup(temp);
    }
    | expression '<' expression
    {
        char *temp = new_temp_var();
        fprintf(output_file, "%s = %s < %s\n", temp, $1, $3);
        $$ = strdup(temp);
    }
    | expression '>' expression
    {
        char *temp = new_temp_var();
        fprintf(output_file, "%s = %s > %s\n", temp, $1, $3);
        $$ = strdup(temp);
    }
    | '(' expression ')'
    {
        $$ = strdup($2);
    }
    | '+' expression %prec UMINUS
    {
        char *temp = new_temp_var();
        fprintf(output_file, "%s = +%s\n", temp, $2);
        $$ = strdup(temp);
    }
    | '-' expression %prec UMINUS
    {
        char *temp = new_temp_var();
        fprintf(output_file, "%s = -%s\n", temp, $2);
        $$ = strdup(temp);
    }
;

%%

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        printf("Error opening input file.\n");
        return 1;
    }

    output_file = fopen("output.tac", "w");
    if (!output_file) {
        printf("Error opening output file.\n");
        return 1;
    }

    yyin = input_file;
    yyparse();

    fclose(input_file);
    fclose(output_file);

    return 0;
}