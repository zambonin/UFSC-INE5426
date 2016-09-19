%{
#include "ast.h"
#include "st.h"

ST::SymbolTable symbolTable;
AST::BlockNode *root;

extern int yylex();
extern void yyerror(const char* s, ...);
%}

%define parse.trace

%union {
    int integer;
    AST::Node *node;
    AST::BlockNode *block;
    const char *name;
}

%token <integer> INT
%token NL COMMA T_INT ASSIGN LPAR RPAR
%token <name> ID

%type <node> expr line varlist
%type <block> lines program

%left PLUS MINUS
%left TIMES DIV
%nonassoc error

%start program

%%

program :
        %empty              {}
        | lines             { root = $1; }
        ;

lines   :
        line                { $$ = new AST::BlockNode();
                              if ($1 != NULL) $$->nodeList.push_back($1); }
        | lines line        { if ($2 != NULL) $1->nodeList.push_back($2); }
        | lines error NL    { yyerrok; }
        ;

line    :
        NL                  { $$ = 0; }
        | expr NL
        | T_INT varlist NL  { $$ = $2; }
        | ID ASSIGN expr    { AST::Node* n = symbolTable.assignVariable($1);
                              $$ = new AST::BinaryOpNode(AST::assign, n, $3); }
        ;

expr    :
        INT                 { $$ = new AST::IntNode($1); }
        | ID                { $$ = symbolTable.useVariable($1); }
        | expr PLUS expr    { $$ = new AST::BinaryOpNode(AST::add, $1, $3); }
        | expr MINUS expr   { $$ = new AST::BinaryOpNode(AST::sub, $1, $3); }
        | expr TIMES expr   { $$ = new AST::BinaryOpNode(AST::mul, $1, $3); }
        | expr DIV expr     { $$ = new AST::BinaryOpNode(AST::divs, $1, $3); }
        | LPAR expr RPAR    { $$ = $2; }
        ;

varlist :
        ID                  { $$ = symbolTable.newVariable($1, NULL); }
        | varlist COMMA ID  { $$ = symbolTable.newVariable($3, $1); }
        ;

%%
