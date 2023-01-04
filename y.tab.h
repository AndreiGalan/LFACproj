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
    TYPE = 258,
    SINGLECHAR = 259,
    CONST = 260,
    BEGIN_BLOC = 261,
    END_BLOC = 262,
    IF = 263,
    ELSE = 264,
    WHILE = 265,
    FOR = 266,
    CLASS = 267,
    CLASS_SPEC = 268,
    BOOL_TRUE = 269,
    BOOL_FALSE = 270,
    LESS = 271,
    LESSOREQ = 272,
    GREATER = 273,
    GREATEROREQ = 274,
    PLUS = 275,
    MINUS = 276,
    MULT = 277,
    SLASH = 278,
    AND = 279,
    OR = 280,
    NEG = 281,
    STR_OP = 282,
    ID = 283,
    ASSIGN = 284,
    FLOAT = 285,
    NR = 286,
    LB = 287,
    RB = 288,
    STRING = 289
  };
#endif
/* Tokens.  */
#define TYPE 258
#define SINGLECHAR 259
#define CONST 260
#define BEGIN_BLOC 261
#define END_BLOC 262
#define IF 263
#define ELSE 264
#define WHILE 265
#define FOR 266
#define CLASS 267
#define CLASS_SPEC 268
#define BOOL_TRUE 269
#define BOOL_FALSE 270
#define LESS 271
#define LESSOREQ 272
#define GREATER 273
#define GREATEROREQ 274
#define PLUS 275
#define MINUS 276
#define MULT 277
#define SLASH 278
#define AND 279
#define OR 280
#define NEG 281
#define STR_OP 282
#define ID 283
#define ASSIGN 284
#define FLOAT 285
#define NR 286
#define LB 287
#define RB 288
#define STRING 289

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
