{ open Parser }

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "//" { linec lexbuf }
| "/*" { comment 0 lexbuf } (* Comments *)
| ';' { SEMI }
| '=' { ASSIGN }
| '(' { LPAREN }
| ')' { RPAREN }
| '{' { LBRACE }
| '}' { RBRACE }
| ',' { COMMA }
| "func" { FUNC }
| "int" { INT }
| "float" { FLOAT }
| "string" { STRING }
| "bool" { BOOL }
| "any" { ANY }
| "void" { VOID }
| "return" { RETURN }
| "elif" { ELIF }
| "if" { IF }
| "else" { ELSE }
| "for" { FOR }
| "true"|"false" as lxm { BOOLLIT(bool_of_string lxm) }
| ['0'-'9']+ as lxm { INTLIT(int_of_string lxm) }
| ['0'-'9']*"."['0'-'9']+ as lxm { FLOATLIT(float_of_string lxm) }
| ['a'-'z']['a'-'z' 'A'-'Z' '0'-'9']* as lxm { ID(lxm) }
| eof { EOF }

and comment level = parse
  "*/" { match level with 0 -> token lexbuf | _ -> comment (level - 1) lexbuf }
| "/*" { comment (level + 1) lexbuf }
| _ { comment level lexbuf }

and linec = parse
  '\n' { token lexbuf }
| _ { linec lexbuf }