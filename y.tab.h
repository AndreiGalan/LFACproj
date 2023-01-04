/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    MAIN = 258,
    CONST = 259,
    INT = 260,
    FLOAT = 261,
    STRING = 262,
    CHAR = 263,
    BOOL = 264,
    PROCEDURE = 265,
    FUNCTION = 266,
    ARROW = 267,
    RETURN = 268,
    VOID = 269,
    IF = 270,
    ELSE = 271,
    WHILE = 272,
    FOR = 273,
    CLASS = 274,
    CLASS_SPEC = 275,
    MEMBER_ACCESS = 276,
    NEQ = 277,
    EQ = 278,
    LESS = 279,
    LESSOREQ = 280,
    GREATER = 281,
    GREATEROREQ = 282,
    INCREMENT = 283,
    DECREMENT = 284,
    PLUS = 285,
    MINUS = 286,
    MULT = 287,
    SLASH = 288,
    PLUSA = 289,
    MINUSA = 290,
    MULTA = 291,
    SLASHA = 292,
    REMAIDER = 293,
    AND = 294,
    OR = 295,
    NEG = 296,
    ASSIGN = 297,
    INT_CONST = 298,
    FLOAT_CONST = 299,
    CHAR_CONST = 300,
    STRING_CONST = 301,
    ID = 302,
    TYPEOF = 303,
    BOOL_CONST = 304
  };
#endif
/* Tokens.  */
#define MAIN 258
#define CONST 259
#define INT 260
#define FLOAT 261
#define STRING 262
#define CHAR 263
#define BOOL 264
#define PROCEDURE 265
#define FUNCTION 266
#define ARROW 267
#define RETURN 268
#define VOID 269
#define IF 270
#define ELSE 271
#define WHILE 272
#define FOR 273
#define CLASS 274
#define CLASS_SPEC 275
#define MEMBER_ACCESS 276
#define NEQ 277
#define EQ 278
#define LESS 279
#define LESSOREQ 280
#define GREATER 281
#define GREATEROREQ 282
#define INCREMENT 283
#define DECREMENT 284
#define PLUS 285
#define MINUS 286
#define MULT 287
#define SLASH 288
#define PLUSA 289
#define MINUSA 290
#define MULTA 291
#define SLASHA 292
#define REMAIDER 293
#define AND 294
#define OR 295
#define NEG 296
#define ASSIGN 297
#define INT_CONST 298
#define FLOAT_CONST 299
#define CHAR_CONST 300
#define STRING_CONST 301
#define ID 302
#define TYPEOF 303
#define BOOL_CONST 304

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 72 "limbaj.y"
 
  int valINT;
  float valFLOAT;
  char valCHAR;
  char* valSTRING;
  int valBOOL;
  union Value* valEXPR;
  struct Variable* variable;

#line 165 "y.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
