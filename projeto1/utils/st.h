/*
 *  Symbol table structure for a language called
 *  Łukasiewicz, based on prefix notation.
 *
 *  Authors: Douglas Martins, Gustavo Zambonin,
 *           Marcello Klingelfus
 */
#pragma once

#include <map>
#include "ast.h"

extern void yyerror(const char *s, ...);

namespace ST {

  // Enumeration of variable types.
  enum VarType { integer };

  // Enumeration of variable kinds.
  enum VarKind { variable };

  class Symbol {
  public:
    // Type of symbol.
    VarType type;

    // Kind of symbol.
    VarKind kind;

    // Holds a value if the symbol kind is a variable.
    int64_t value;

    // Status of the symbol initialization if it is a variable.
    bool init;

    // Constructor for the Symbol class.
    Symbol(VarType type, VarKind kind, int64_t value, bool init):
      type(type), kind(kind), value(value), init(init) {}

    // Initial status for the Symbol object.
    Symbol() {
      type = integer;
      kind = variable;
      value = 0;
      init = false;
    }
  };

  class SymbolTable {
  public:
    // Map that holds pairs consisting of a variable
    // name and its related Symbol object.
    std::map<std::string, Symbol> entryList;

    // Constructor for the SymbolTable class.
    SymbolTable() {}

    // Searches for a given key, representing a variable, on the symbol
    // table. Since all keys are unique, it may only return 0 or 1.
    bool varExists(std::string key) {
      return (bool) entryList.count(key);
    }

    // Adds an entry to the symbol table map.
    void addSymbol(std::string key, Symbol symbol) {
      entryList[key] = symbol;
    }

    // Creates a new variable inside the map.
    AST::Node* newVariable(std::string id, AST::Node* next);

    // Sets a value to some variable.
    AST::Node* assignVariable(std::string id, AST::Node* next);

    // Creates a copy of the variable named `id` for
    // references on the code.
    AST::Node* useVariable(std::string id);
  };

}
