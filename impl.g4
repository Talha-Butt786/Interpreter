grammar impl;

/* A small imperative language */

start   :  cs+=command* EOF ;

program : c=command                      # SingleCommand
	| '{' cs+=command* '}'           # MultipleCommands
	;
	
command : x=ID '=' e=expr ';'	         # Assignment
      | x=ID'[' e1=expr ']' '=' e2=expr ';' #Arrays
	  | 'output' e=expr ';'            # Output
        | 'while' '('c=condition')' p=program  # WhileLoop
        | 'if' '('c=condition')' 'then'? p=program  # IfStatement
        | 'for' '(' x=ID '=' e=expr '..' y=expr')' p=program  # ForLoop


	;
	
expr	: c=FLOAT     	            # Constant
		| e1=expr op=MULDIV e2=expr # MultiplicationandDivision
        | e1=expr op=ADDSUB e2=expr # AdditionandSubstraction
	    | op=ADDSUB c=FLOAT         # Minus
	    | x=ID		                # Variable
	    | '(' e=expr ')'            # Parenthesis
	    | x=ID '['e1=expr']'  #ArrayVariable


	;

condition : e1=expr '!=' e2=expr #Unequal
          | e1=expr '>' e2=expr #Biggerthan
          | e1=expr '<' e2=expr #Lessthan
          | e1=expr '>=' e2=expr #BiggerthanEqual
          | e1=expr '<=' e2=expr #LessthanEqual
          | e1=expr '==' e2=expr #Equal
          | e1=condition '&&' e2=condition #LogicalAnd
          | e1=condition '||' e2=condition #LogicalOr
          | '!' e1=condition  #Not


	  ;  
MULDIV : ('*'|'/');
ADDSUB : ('+'|'-');
BIGGERORLESS : ('>'|'<');
ID    : ALPHA (ALPHA|NUM)* ;
FLOAT : NUM+ ('.' NUM+)? ;

ALPHA : [a-zA-Z_ÆØÅæøå] ;
NUM   : [0-9] ;

WHITESPACE : [ \n\t\r]+ -> skip;
COMMENT    : '//'~[\n]*  -> skip;
COMMENT2   : '/*' (~[*] | '*'~[/]  )*   '*/'  -> skip;
