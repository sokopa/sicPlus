%{

#include <stdbool.h>
#include <stdio.h>
#include <unistd.h>

long long nestedComments = 0;
long long lineCount = 1;
void yyerror( const char msg [] );

%}

DIGIT 			[0-9]
LETTER			[A-Za-z]
HEX			{DIGIT}|[a-fA-F]
UNSCR			[_]
QSTMRK			[?]
CHAR			{LETTER}|{UNSCR}|{QSTMRK}
WSPACE			[\t\r ]
NLINE			[\n]
DIGCHAR			{DIGIT}|{CHAR}
VALID			[^\n\"\'\\]|\\n|\\t|\\\'|\\\"|\\\\|\\{HEX}{2}
INVALID			\\[^nt\'\"\\]

IDENTIFIER		{LETTER}({LETTER}|{DIGIT})*
NUMBER			{DIGIT}+


%x	MULCOMMENT
%X	COMMENT

%%

{WSPACE}*		{ /* White space. Do nothing */ }
"and" 			{ return T_and; }
"bool"			{ return T_bool; }
"char"			{ return T_char; }
"decl" 			{ return T_decl; }
"def"			{ return T_def; }
"else"			{ return T_else; }
"elsif"			{ return T_elsif; }
"end"			{ return T_end; }
"exit"			{ return T_exit; }
"false"			{ return T_false; }
"for"			{ return T_for; }
"head"			{ return T_head; }
"if"			{ return T_if; }
"int"			{ return T_int; }
"list"			{ return T_list; }
"mod"			{ return T_mod; }
"new"			{ return T_new; }
"nil"			{ return T_nil; }
"nil?"			{ return T_nilqstn; }
"not"			{ return T_not; }
"or"			{ return T_or; }
"ref"			{ return T_ref; }
"return"		{ return T_return; }
"skip"			{ return T_skip; }
"tail"			{ return T_tail; }
"true"			{ return T_true; }

{IDENTIFIER}		{ yylval.n = (char *) malloc(sizeof(yytext)); strcpy(yylval.n, yytext); return T_id; }
{NUMBER}		{ yylval.v.val = atoi(yytext); return T_number; }

<INITIAL,MULCOMMENT>{NLINE} { lineCount++; }
"<*"			{ BEGIN(MULCOMMENT); nestedComments++; }
<MULCOMMENT>[^<*\n]*	{ /* Inside comment, do nothing */ }
<COMMENT>[^\n]*		{ /* also nothing */ }
"%"+[.]*		{ BEGIN(COMMENT); }
<COMMENT>{NLINE}	{ lineCount++; BEGIN(INITIAL); }

