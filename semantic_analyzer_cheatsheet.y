// Semantic analysis checks if the variable is declared before and if it's data type is as expected.

// ++ and -- operators (both of them is working only on integer values)
expression:
T_ID T_INC
{ 
  /* works only on variables that are declared */ 
  if( symbol_table.count(*$1) == 0 )
  {
    std::stringstream ss;
    ss << "Undeclared variable: " << *$1 << std::endl;
    error( ss.str().c_str() );
  }
  /* works only on variables that has an integer type */
  if(symbol_table[*$1].decl_type != integer)
  {
    std::stringstream ss;
    ss << "Non-integer value can not be incremented!" << std::endl;
    error( ss.str().c_str() );
  }
  /* return type will be integer */
  $$ = new type(integer);
  /* frees the memory */
  delete $1;
}


// for loop (with a syntax like this: for <var> := <expr> to <expr> do <stmts> done)
loop:
T_FOR T_ID T_ASSIGN expression T_TO expression T_DO statements T_DONE
{
  /* checks if the <var> is declared */
  if( symbol_table.count(*$2) == 0 )
  {
    std::stringstream ss;
    ss << "Undeclared variable: " << *$2 << std::endl;
    error( ss.str().c_str() );
  }
  /* checks if the <var>, and both <expr> is of type integer */
  if(symbol_table[*$2].decl_type != integer || *$4 != integer || *$6 != integer)
  {
    std::stringstream ss;
    ss << d_loc__.first_line << ": Type error." << std::endl;
    error( ss.str().c_str() );
  }
  // 
  delete $2;
  delete $4;
  delete $6;
}


// time type (you can start off with this implementation - the lexical&syntax parts are done already)
declaration:
T_TIME T_ID T_SEMICOLON
{
  if( symbol_table.count(*$2) > 0 )
  {
    std::stringstream ss;
    ss << "Re-declared variable: " << *$2 << ".\n"
    << "Line of previous declaration: " << symbol_table[*$2].decl_row << std::endl;
    error( ss.str().c_str() );
  }
  // when the variable is declared for the first time, add it to the symbol table
  // var_data(int lineIndex, type variableType)
  symbol_table[*$2] = var_data( d_loc__.first_line, time_type );
  delete $2;
}

// extend the type-system with the new 'time_type' type
expression:
T_TIME_LIT 
{
    $$ = new type(time_type);
}

// the hour(...) and minute(...) functions can only accept a time typed expression
T_HOUR T_OPEN expression T_CLOSE
    {
        if(*$3 != time_type)
    {
       std::stringstream ss;
       ss << d_loc__.first_line << ": Type error." << std::endl;
       error( ss.str().c_str() );
    }
        $$ = new type(integer);
        delete $3;
    }
|
T_MINUTE T_OPEN expression T_CLOSE
{
    if(*$3 != time_type)
    {
       std::stringstream ss;
       ss << d_loc__.first_line << ": Type error." << std::endl;
       error( ss.str().c_str() );
    }
    $$ = new type(integer);
    delete $3;
}

// other binary operators behavior is not defined for the time type
expression T_EQ expression
{
    if(*$1 != *$3 || *$1==time_type)
    {
       std::stringstream ss;
       ss << d_loc__.first_line << ": Type error." << std::endl;
       error( ss.str().c_str() );
    }
    $$ = new type(boolean);
    delete $1;
    delete $3;
}