/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "limbaj.y"

#include <stdio.h>
#include "includes.h"
#include "stack.h"
#include <string.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;

int array_type = 0;

struct Function* functions[100];
int nr_functions = 0;

int* params;
char** params_name; 
int nr_params = 0;

void write_to_file(Variable* var);
void write_function_to_file(Function* func);

int find_function_name(char* name)
{
	for(int i = 0; i < nr_functions; ++i)
		if(strcmp(functions[i]->name, name) == 0)
			return 0;

	return -1;
}

void free_functions()
{
	for(int i = 0; i < nr_functions; ++i){
		free(functions[i]->name);
		free(functions[i]->parameters);
		free(functions[i]);
	}
}


struct Stack* stack_scope[100];
int curr_pos = -1;

struct Node* GlobalVar = NULL;

void free_const(struct Variable* v);

void free_stack_global()
{
	delete_list(&GlobalVar);
	for(int i = 0; i < curr_pos; ++i)
		freeStack(stack_scope[i]);
}

struct Variable* general_lookup(const char* name)
{
	struct Variable* var = lookup_element(GlobalVar, name);

	if(curr_pos >= 0 ){
		for(int i = 0; i <= stack_scope[curr_pos]->top; ++i){
			if(var != NULL)
				return var;
			var = lookup_element(stack_scope[curr_pos]->data[i], name);
		}
	}
	return var;
}


#line 140 "y.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
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

#line 300 "y.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_uint8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   391

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  58
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  43
/* YYNRULES -- Number of rules.  */
#define YYNRULES  105
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  229

#define YYUNDEFTOK  2
#define YYMAXUTOK   304


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      53,    54,     2,     2,    55,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,    50,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    56,     2,    57,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,    51,     2,    52,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   118,   118,   118,   136,   137,   141,   145,   146,   149,
     149,   153,   156,   157,   158,   159,   165,   164,   183,   182,
     215,   245,   274,   277,   278,   278,   279,   279,   280,   281,
     282,   283,   284,   287,   291,   291,   339,   351,   362,   367,
     382,   400,   443,   485,   485,   507,   507,   532,   542,   552,
     555,   556,   557,   558,   559,   567,   574,   581,   590,   597,
     606,   607,   608,   611,   612,   613,   614,   618,   650,   651,
     678,   708,   709,   716,   769,   797,   825,   862,   886,   887,
     902,   903,   904,   905,   906,   910,   923,   945,   968,   991,
    1013,  1035,  1060,  1071,  1075,  1075,  1081,  1081,  1085,  1085,
    1091,  1091,  1095,  1095,  1099,  1095
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "MAIN", "CONST", "INT", "FLOAT",
  "STRING", "CHAR", "BOOL", "PROCEDURE", "FUNCTION", "ARROW", "RETURN",
  "VOID", "IF", "ELSE", "WHILE", "FOR", "CLASS", "CLASS_SPEC",
  "MEMBER_ACCESS", "NEQ", "EQ", "LESS", "LESSOREQ", "GREATER",
  "GREATEROREQ", "INCREMENT", "DECREMENT", "PLUS", "MINUS", "MULT",
  "SLASH", "PLUSA", "MINUSA", "MULTA", "SLASHA", "REMAIDER", "AND", "OR",
  "NEG", "ASSIGN", "INT_CONST", "FLOAT_CONST", "CHAR_CONST",
  "STRING_CONST", "ID", "TYPEOF", "BOOL_CONST", "';'", "'{'", "'}'", "'('",
  "')'", "','", "'['", "']'", "$accept", "program", "$@1", "prog_parts",
  "MAIN_BLOC", "$@2", "class", "class_block", "function", "$@3", "$@4",
  "params", "function_block", "$@5", "$@6", "rtn", "function_call", "$@7",
  "params_call", "declaration", "definition", "$@8", "$@9", "arr_item",
  "TYPE", "constant_value", "assignments", "shortcuts", "assignment",
  "operations", "bool_statement", "bool_expresion", "item", "while",
  "$@10", "for", "$@11", "$@12", "if", "$@13", "$@14", "$@15", "$@16", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
      59,   123,   125,    40,    41,    44,    91,    93
};
# endif

#define YYPACT_NINF (-174)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-86)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -174,     9,  -174,  -174,   336,  -174,   291,  -174,  -174,  -174,
    -174,  -174,   -27,   -23,    -2,  -174,  -174,  -174,    -4,    16,
       1,    17,     2,  -174,  -174,    23,  -174,  -174,   -20,  -174,
     -15,   -11,    28,  -174,   319,    43,   129,   319,    50,   291,
     291,   -14,   330,  -174,  -174,  -174,  -174,    46,  -174,   319,
    -174,  -174,   122,   -10,  -174,    -8,    45,    52,    53,    54,
     245,  -174,    70,  -174,  -174,    94,    92,  -174,  -174,  -174,
     122,    99,    95,   104,   118,   119,   380,  -174,  -174,   330,
    -174,   326,   121,   218,   -28,   319,   319,   319,   319,   319,
     330,   330,   155,   155,   155,   155,   155,   155,   130,   330,
     330,    83,  -174,  -174,  -174,  -174,  -174,  -174,   319,   319,
    -174,   125,   128,   245,   138,  -174,  -174,   157,   291,   133,
     198,  -174,   161,   163,   -28,   319,  -174,  -174,    44,    44,
    -174,  -174,  -174,  -174,   173,  -174,  -174,  -174,  -174,  -174,
    -174,   179,    55,    58,   177,   184,   182,   122,   122,  -174,
    -174,  -174,   191,  -174,  -174,   193,   291,  -174,  -174,   180,
     152,   186,  -174,  -174,   330,    -9,   330,   187,   162,   196,
     206,  -174,   319,   319,   208,   209,   210,    71,   219,   100,
     319,  -174,  -174,  -174,  -174,   224,   192,  -174,  -174,  -174,
      94,   213,    94,   231,   110,  -174,   319,   188,   211,   237,
     185,  -174,   217,  -174,   155,   233,  -174,  -174,  -174,  -174,
    -174,  -174,   236,  -174,   272,   251,   254,  -174,  -174,  -174,
    -174,   255,   260,   286,  -174,  -174,  -174,   309,  -174
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       2,     0,     8,     1,     0,     9,     0,    50,    51,    52,
      53,    54,     0,     0,     0,     3,     7,     4,     0,     0,
       0,     0,     0,    16,    18,     0,     5,     6,    39,    32,
       0,     0,     0,    15,     0,     0,     0,     0,     0,    22,
      22,     0,     0,    55,    56,    58,    57,    92,    59,     0,
      79,    93,    42,    72,    80,    71,     0,     0,     0,     0,
      34,    10,     0,    24,    26,    23,     0,    29,    30,    31,
      41,     0,     0,    21,     0,     0,     0,    11,    92,     0,
      84,    85,     0,     0,    72,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    40,     0,
       0,     0,    69,    70,    63,    64,    65,    66,     0,     0,
      28,     0,     0,     0,     0,    60,    43,     0,    22,    39,
       0,    12,     0,     0,     0,    38,    78,    81,    73,    74,
      76,    75,    77,    82,    83,    86,    87,    88,    89,    90,
      91,     0,     0,     0,     0,     0,     0,    67,    68,    25,
      27,    61,     0,    32,    20,     0,     0,    13,    14,     0,
      37,     0,   100,    94,     0,     0,     0,     0,     0,     0,
       0,    35,    38,    49,     0,     0,     0,     0,     0,     0,
      49,    17,    40,    32,    36,     0,    48,    32,    32,    32,
       0,     0,     0,     0,     0,    46,    49,     0,     0,     0,
       0,    45,     0,    44,     0,     0,    47,   101,   103,    95,
      96,    98,     0,    19,     0,     0,     0,    33,   104,    32,
      32,     0,     0,     0,    32,    97,    99,     0,   105
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -174,  -174,  -174,  -174,  -174,  -174,  -174,  -174,   232,  -174,
    -174,   -35,  -116,  -174,  -174,  -174,   -36,  -174,   137,     4,
      -1,  -174,  -174,  -173,    -5,  -174,  -174,  -174,   -61,   -24,
     -21,  -174,   -40,  -174,  -174,  -174,  -174,  -174,  -174,  -174,
    -174,  -174,  -174
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     4,    15,    21,    16,    41,    17,    31,
      32,    72,    36,   111,   112,   205,    50,    82,   159,    63,
      64,   152,   141,   185,    20,    51,    65,   109,    66,   186,
      53,    54,    55,    67,   176,    68,   215,   216,    69,   174,
     175,   214,   221
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      62,    22,    81,    19,   114,    75,    76,   193,    18,     3,
      52,    90,    91,    70,    92,    93,    94,    95,    96,    97,
      23,    80,    34,   206,    24,    83,   127,    37,    84,    90,
      91,   -85,   -85,    34,    74,    74,    35,   168,    77,    81,
     146,    38,    39,    73,    73,    25,    26,   178,    28,    30,
      81,    81,   135,   136,   137,   138,   139,   140,   124,    81,
      81,   128,   129,   130,   131,   132,    27,   194,    29,   133,
     134,   197,   198,   199,    33,   123,    87,    88,   142,   143,
     122,    40,    89,   154,   147,   148,    56,     6,     7,     8,
       9,    10,    11,    71,    90,    91,   145,    90,    91,   -34,
     144,   160,    98,   222,   223,    99,   100,   101,   227,   162,
      90,    91,   163,    74,     6,     7,     8,     9,    10,    11,
     110,   190,    73,   204,    81,    57,    81,    58,    59,   200,
     113,   202,    62,     6,     7,     8,     9,    10,    11,    90,
      91,   113,   115,   177,    57,   179,    58,    59,   160,   117,
     192,   170,    85,    86,    87,    88,   116,    60,    62,   118,
      89,    62,    62,    62,   212,   119,     6,     7,     8,     9,
      10,    11,   -45,   120,   125,   149,    60,    57,   150,    58,
      59,    61,    85,    86,    87,    88,    62,    62,   151,   155,
      89,    62,     6,     7,     8,     9,    10,    11,    43,    44,
      45,    46,    78,    57,    48,    58,    59,   172,   153,    60,
     156,   157,    90,   158,   181,     6,     7,     8,     9,    10,
      11,   161,    85,    86,    87,    88,    57,   164,    58,    59,
      89,   165,   166,   167,   171,    60,   169,   173,   180,   210,
     207,     6,     7,     8,     9,    10,    11,   196,    85,    86,
      87,    88,    57,   182,    58,    59,    89,   183,    60,   187,
     188,   189,   191,   208,     6,     7,     8,     9,    10,    11,
     201,   211,   126,   102,   103,    57,   195,    58,    59,   104,
     105,   106,   107,   203,    60,   213,   217,   108,   218,   209,
       6,     7,     8,     9,    10,    11,     7,     8,     9,    10,
      11,    57,   219,    58,    59,   220,   224,    60,   121,   184,
       0,     0,   225,     6,     7,     8,     9,    10,    11,     0,
       0,     0,     0,     0,    57,     0,    58,    59,     0,     0,
       0,     0,     0,    60,     0,     0,     0,     0,   226,     5,
       6,     7,     8,     9,    10,    11,    12,    13,    92,    93,
      94,    95,    96,    97,     0,    14,    60,     0,     0,     0,
      42,   228,    43,    44,    45,    46,    47,     0,    48,     0,
       0,    42,    49,    43,    44,    45,    46,    78,     0,    48,
       0,     0,     0,    79,     6,     7,     8,     9,    10,    11,
      12,    13
};

static const yytype_int16 yycheck[] =
{
      36,     6,    42,     4,    65,    40,    20,   180,     4,     0,
      34,    39,    40,    37,    22,    23,    24,    25,    26,    27,
      47,    42,    42,   196,    47,    49,    54,    42,    49,    39,
      40,    39,    40,    42,    39,    40,    56,   153,    52,    79,
     101,    56,    53,    39,    40,    47,    50,    56,    47,    47,
      90,    91,    92,    93,    94,    95,    96,    97,    79,    99,
     100,    85,    86,    87,    88,    89,    50,   183,    51,    90,
      91,   187,   188,   189,    51,    76,    32,    33,    99,   100,
      76,    53,    38,   118,   108,   109,    43,     4,     5,     6,
       7,     8,     9,    43,    39,    40,   101,    39,    40,    53,
     101,   125,    57,   219,   220,    53,    53,    53,   224,    54,
      39,    40,    54,   118,     4,     5,     6,     7,     8,     9,
      50,    50,   118,    13,   164,    15,   166,    17,    18,   190,
      47,   192,   168,     4,     5,     6,     7,     8,     9,    39,
      40,    47,    50,   164,    15,   166,    17,    18,   172,    54,
      50,   156,    30,    31,    32,    33,    57,    47,   194,    55,
      38,   197,   198,   199,   204,    47,     4,     5,     6,     7,
       8,     9,    42,    54,    53,    50,    47,    15,    50,    17,
      18,    52,    30,    31,    32,    33,   222,   223,    50,    56,
      38,   227,     4,     5,     6,     7,     8,     9,    43,    44,
      45,    46,    47,    15,    49,    17,    18,    55,    51,    47,
      12,    50,    39,    50,    52,     4,     5,     6,     7,     8,
       9,    42,    30,    31,    32,    33,    15,    50,    17,    18,
      38,    47,    50,    42,    54,    47,    43,    51,    51,    54,
      52,     4,     5,     6,     7,     8,     9,    55,    30,    31,
      32,    33,    15,    57,    17,    18,    38,    51,    47,    51,
      51,    51,    43,    52,     4,     5,     6,     7,     8,     9,
      57,    54,    54,    28,    29,    15,    52,    17,    18,    34,
      35,    36,    37,    52,    47,    52,    50,    42,    16,    52,
       4,     5,     6,     7,     8,     9,     5,     6,     7,     8,
       9,    15,    51,    17,    18,    51,    51,    47,    76,   172,
      -1,    -1,    52,     4,     5,     6,     7,     8,     9,    -1,
      -1,    -1,    -1,    -1,    15,    -1,    17,    18,    -1,    -1,
      -1,    -1,    -1,    47,    -1,    -1,    -1,    -1,    52,     3,
       4,     5,     6,     7,     8,     9,    10,    11,    22,    23,
      24,    25,    26,    27,    -1,    19,    47,    -1,    -1,    -1,
      41,    52,    43,    44,    45,    46,    47,    -1,    49,    -1,
      -1,    41,    53,    43,    44,    45,    46,    47,    -1,    49,
      -1,    -1,    -1,    53,     4,     5,     6,     7,     8,     9,
      10,    11
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    59,    60,     0,    61,     3,     4,     5,     6,     7,
       8,     9,    10,    11,    19,    62,    64,    66,    77,    78,
      82,    63,    82,    47,    47,    47,    50,    50,    47,    51,
      47,    67,    68,    51,    42,    56,    70,    42,    56,    53,
      53,    65,    41,    43,    44,    45,    46,    47,    49,    53,
      74,    83,    87,    88,    89,    90,    43,    15,    17,    18,
      47,    52,    74,    77,    78,    84,    86,    91,    93,    96,
      87,    43,    69,    77,    82,    69,    20,    52,    47,    53,
      88,    90,    75,    87,    88,    30,    31,    32,    33,    38,
      39,    40,    22,    23,    24,    25,    26,    27,    57,    53,
      53,    53,    28,    29,    34,    35,    36,    37,    42,    85,
      50,    71,    72,    47,    86,    50,    57,    54,    55,    47,
      54,    66,    77,    78,    88,    53,    54,    54,    87,    87,
      87,    87,    87,    88,    88,    90,    90,    90,    90,    90,
      90,    80,    88,    88,    78,    82,    86,    87,    87,    50,
      50,    50,    79,    51,    69,    56,    12,    50,    50,    76,
      87,    42,    54,    54,    50,    47,    50,    42,    70,    43,
      82,    54,    55,    51,    97,    98,    92,    88,    56,    88,
      51,    52,    57,    51,    76,    81,    87,    51,    51,    51,
      50,    43,    50,    81,    70,    52,    55,    70,    70,    70,
      86,    57,    86,    52,    13,    73,    81,    52,    52,    52,
      54,    54,    90,    52,    99,    94,    95,    50,    16,    51,
      51,   100,    70,    70,    51,    52,    52,    70,    52
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    58,    60,    59,    61,    61,    61,    61,    61,    63,
      62,    64,    65,    65,    65,    65,    67,    66,    68,    66,
      69,    69,    69,    70,    71,    70,    72,    70,    70,    70,
      70,    70,    70,    73,    75,    74,    76,    76,    76,    77,
      77,    78,    78,    79,    78,    80,    78,    81,    81,    81,
      82,    82,    82,    82,    82,    83,    83,    83,    83,    83,
      84,    84,    84,    85,    85,    85,    85,    86,    86,    86,
      86,    87,    87,    87,    87,    87,    87,    87,    87,    87,
      88,    88,    88,    88,    88,    89,    89,    89,    89,    89,
      89,    89,    90,    90,    92,    91,    94,    93,    95,    93,
      97,    96,    98,    99,   100,    96
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     0,     3,     2,     3,     3,     2,     0,     0,
       5,     5,     3,     4,     4,     0,     0,     9,     0,    12,
       3,     1,     0,     2,     0,     4,     0,     4,     3,     2,
       2,     2,     0,     3,     0,     5,     3,     1,     0,     2,
       5,     5,     4,     0,    11,     0,    10,     3,     1,     0,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       2,     3,     0,     1,     1,     1,     1,     3,     3,     2,
       2,     1,     1,     3,     3,     3,     3,     3,     3,     1,
       1,     3,     3,     3,     2,     1,     3,     3,     3,     3,
       3,     3,     1,     1,     0,     8,     0,    12,     0,    12,
       0,     8,     0,     0,     0,    14
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 118 "limbaj.y"
                                { 
						FILE* fp = fopen("symbol_table_functions.txt", "w");
						fclose(fp);
						fp = fopen("symbol_table.txt", "w");
						fclose(fp);
					}
#line 1672 "y.tab.c"
    break;

  case 3:
#line 124 "limbaj.y"
                                                                {
											printf("program corect sintactic\n");
											struct Node* current = GlobalVar;

											for(int i = 0; i < nr_functions; ++i)
												write_function_to_file(functions[i]);

											free_stack_global();
											free_functions();
										}
#line 1687 "y.tab.c"
    break;

  case 5:
#line 137 "limbaj.y"
                                                                {
													add_element(&GlobalVar, (yyvsp[-1].variable));
													write_to_file((yyvsp[-1].variable));
												}
#line 1696 "y.tab.c"
    break;

  case 6:
#line 141 "limbaj.y"
                                                                        {
													add_element(&GlobalVar, (yyvsp[-1].variable));
													write_to_file((yyvsp[-1].variable));
												}
#line 1705 "y.tab.c"
    break;

  case 9:
#line 149 "limbaj.y"
                               {printf("main\n"); stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);}
#line 1711 "y.tab.c"
    break;

  case 16:
#line 165 "limbaj.y"
                                                        {	
								if(find_function_name((yyvsp[0].valSTRING)) == 0){
									free_stack_global();
									free_functions();
									printf("Error at line: %d\n", yylineno);
									printf("The function is already delcared!!!\n");
									exit(1);
								}
								stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);
								functions[nr_functions] = (struct Function*)malloc(sizeof(struct Function));
								functions[nr_functions]->name = (char*)malloc((strlen((yyvsp[0].valSTRING))+1)*sizeof(char));
								strcpy(functions[nr_functions]->name, (yyvsp[0].valSTRING));
								functions[nr_functions]->nr_parameters = 0;
								functions[nr_functions]->return_type = -1;
							}
#line 1731 "y.tab.c"
    break;

  case 17:
#line 180 "limbaj.y"
                                                                                              {++nr_functions; freeStack(stack_scope[curr_pos--]);}
#line 1737 "y.tab.c"
    break;

  case 18:
#line 183 "limbaj.y"
                                                        {	
								if(find_function_name((yyvsp[0].valSTRING)) == 0){
									free_stack_global();
									free_functions();
									printf("Error at line: %d\n", yylineno);
									printf("The function is already delcared!!!\n");
									exit(1);
								}
								stack_scope[++curr_pos] = createStack(); push(stack_scope[curr_pos]);
								functions[nr_functions] = (struct Function*)malloc(sizeof(struct Function));
								functions[nr_functions]->name = (char*)malloc((strlen((yyvsp[0].valSTRING))+1)*sizeof(char));
								strcpy(functions[nr_functions]->name, (yyvsp[0].valSTRING));
								functions[nr_functions]->nr_parameters = 0;
							}
#line 1756 "y.tab.c"
    break;

  case 19:
#line 198 "limbaj.y"
                                                                                                                                                                {	
																					if((yyvsp[-1].variable)->type != (yyvsp[-4].valINT)){
																						free_stack_global();
																						free_functions();
																						//free_const($11);
																						printf("Error at line: %d\n", yylineno);
																						printf("The return type is incorect!!!\n");
																						exit(1);
																					}

																					functions[nr_functions]->return_type = (yyvsp[-4].valINT);
																					++nr_functions;
																					freeStack(stack_scope[curr_pos--]);
																				}
#line 1775 "y.tab.c"
    break;

  case 20:
#line 216 "limbaj.y"
                                                                                        {
												++functions[nr_functions]->nr_parameters; 
												int* temp1 = (int*)malloc(functions[nr_functions]->nr_parameters * sizeof(int));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp1, functions[nr_functions]->parameters, (functions[nr_functions]->nr_parameters -1) * sizeof(int));

												temp1[functions[nr_functions]->nr_parameters - 1] = (yyvsp[-2].variable)->type;
												free_const((yyvsp[-2].variable));

												free(functions[nr_functions]->parameters);

												functions[nr_functions]->parameters = temp1;


												char** temp2 = (char**)malloc(functions[nr_functions]->nr_parameters * sizeof(char*));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp2, functions[nr_functions]->parameters_name, (functions[nr_functions]->nr_parameters -1) * sizeof(char*));

												temp2[functions[nr_functions]->nr_parameters - 1] = (char*)malloc((strlen((yyvsp[-2].variable)->name) + 1) * sizeof(char));
												strcpy(temp2[functions[nr_functions]->nr_parameters - 1], (yyvsp[-2].variable)->name);
												printf("%s\n", (yyvsp[-2].variable)->name);
												free_const((yyvsp[-2].variable));

												free(functions[nr_functions]->parameters_name);

												functions[nr_functions]->parameters_name = temp2;
											}
#line 1809 "y.tab.c"
    break;

  case 21:
#line 245 "limbaj.y"
                                                                {
												++functions[nr_functions]->nr_parameters; 
												int* temp1 = (int*)malloc(functions[nr_functions]->nr_parameters * sizeof(int));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp1, functions[nr_functions]->parameters, (functions[nr_functions]->nr_parameters -1) * sizeof(int));

												temp1[functions[nr_functions]->nr_parameters - 1] = (yyvsp[0].variable)->type;
												free_const((yyvsp[0].variable));

												free(functions[nr_functions]->parameters);

												functions[nr_functions]->parameters = temp1;


												char** temp2 = (char**)malloc(functions[nr_functions]->nr_parameters * sizeof(char*));

												if(functions[nr_functions]->nr_parameters > 1)
													memcpy(temp2, functions[nr_functions]->parameters_name, (functions[nr_functions]->nr_parameters -1) * sizeof(char*));

												temp2[functions[nr_functions]->nr_parameters - 1] = (char*)malloc((strlen((yyvsp[0].variable)->name) + 1) * sizeof(char));
												strcpy(temp2[functions[nr_functions]->nr_parameters - 1], (yyvsp[0].variable)->name);
												printf("%s\n", (yyvsp[0].variable)->name);
												free_const((yyvsp[0].variable));

												free(functions[nr_functions]->parameters_name);

												functions[nr_functions]->parameters_name = temp2;
											}
#line 1843 "y.tab.c"
    break;

  case 24:
#line 278 "limbaj.y"
                                                             { add_element(peek(stack_scope[curr_pos]), (yyvsp[0].variable)); write_to_file((yyvsp[0].variable)); }
#line 1849 "y.tab.c"
    break;

  case 26:
#line 279 "limbaj.y"
                                                            { add_element(peek(stack_scope[curr_pos]), (yyvsp[0].variable)); write_to_file((yyvsp[0].variable)); }
#line 1855 "y.tab.c"
    break;

  case 33:
#line 287 "limbaj.y"
                                          {(yyval.variable) = (yyvsp[-1].variable);}
#line 1861 "y.tab.c"
    break;

  case 34:
#line 291 "limbaj.y"
                                        {
							if(find_function_name((yyvsp[0].valSTRING)) == -1){
								free_stack_global();
								free_functions();
								printf("Error at line: %d\n", yylineno);
								printf("The function has not been declared!!!\n");
								exit(1);
							}		
						}
#line 1875 "y.tab.c"
    break;

  case 35:
#line 300 "limbaj.y"
                                                                        {
												for(int i = 0; i < nr_functions; ++i){
													if(strcmp(functions[i]->name, (yyvsp[-4].valSTRING)) == 0){
														if(functions[i]->nr_parameters != nr_params){
															free_stack_global();
															free_functions();
															printf("Error at line: %d\n", yylineno);
															printf("You provided the wrong number of parameters!!!\n");
															exit(1);
														}

														for(int j = 0; j < functions[i]->nr_parameters; ++j){
															if(functions[i]->parameters[j] != params[j]){
																free_stack_global();
																free_functions();
																printf("Error at line: %d\n", yylineno);
																printf("The parameters are of wrong type!!!\n");
																exit(1);
															}
														}

														(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
														(yyval.variable)->name = (char*)malloc((strlen("@const")+1)*sizeof(char));
														strcpy((yyval.variable)->name, "@const");
														(yyval.variable)->type = functions[i]->return_type;
														(yyval.variable)->value.valINT = 0;
													}
												}

												free(params);
												free(params_name);
												params = NULL;
												params_name = NULL;
												nr_params = 0;
											}
#line 1915 "y.tab.c"
    break;

  case 36:
#line 340 "limbaj.y"
                                                                                        {
												int* temp = (int*)malloc(sizeof(int) * (nr_params+1));
												if(nr_params > 0)
													memcpy(temp, params, sizeof(int) * nr_params);

												temp[nr_params++] = (yyvsp[-2].variable)->type;
												free_const((yyvsp[-2].variable));

												free(params);
												params = temp;
											}
#line 1931 "y.tab.c"
    break;

  case 37:
#line 351 "limbaj.y"
                                                                        {
												int* temp = (int*)malloc(sizeof(int) * (nr_params+1));
												if(nr_params > 0)
													memcpy(temp, params, sizeof(int) * nr_params);

												temp[nr_params++] = (yyvsp[0].variable)->type;
												free_const((yyvsp[0].variable));

												free(params);
												params = temp;
											}
#line 1947 "y.tab.c"
    break;

  case 39:
#line 367 "limbaj.y"
                                                                                                        {
															if(general_lookup((yyvsp[0].valSTRING)) != NULL){
																free_stack_global();
																free_functions();
																printf("Error at line: %d\n", yylineno);
																printf("The variable is already declared!!!\n");
																exit(1);
															}
															(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
															(yyval.variable)->name = (yyvsp[0].valSTRING);
															(yyval.variable)->type = (yyvsp[-1].valINT);
															(yyval.variable)->is_const = 0;
															(yyval.variable)->size = 0;
															(yyval.variable)->value.valINT = 0;
														}
#line 1967 "y.tab.c"
    break;

  case 40:
#line 382 "limbaj.y"
                                                                                {
															if(general_lookup((yyvsp[-3].valSTRING)) != NULL){
																free_stack_global();
																free_functions();
																printf("Error at line: %d\n", yylineno);
																printf("The variable is already declared!!!\n");
																exit(1);
															}
															(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
															(yyval.variable)->name = (yyvsp[-3].valSTRING);
															(yyval.variable)->type = (yyvsp[-4].valINT);
															(yyval.variable)->is_const = 0;
															(yyval.variable)->size = (yyvsp[-1].valINT);
															(yyval.variable)->value.valINT = 0;
														}
#line 1987 "y.tab.c"
    break;

  case 41:
#line 400 "limbaj.y"
                                                                                {
															if(general_lookup((yyvsp[-2].valSTRING)) != NULL){
																free_stack_global();
																free_functions();
																free_const((yyvsp[0].variable));
																printf("Error at line: %d\n", yylineno);
																printf("The variable is already declared!!!\n");
																exit(1);
															}
																	
															if((yyvsp[-3].valINT) != (yyvsp[0].variable)->type){
																free_stack_global();
																free_functions();
																free_const((yyvsp[0].variable));
																printf("Error at line: %d\n", yylineno);
																printf("The types are incompatible!!!\n");
        														exit(1);
															}

															if(strcmp((yyvsp[0].variable)->name, "@const") == 0){
																(yyval.variable) = (yyvsp[0].variable);
																(yyval.variable)->name = (yyvsp[-2].valSTRING);
																(yyval.variable)->is_const = 1;
															}
															else{
																(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
																(yyval.variable)->name = (yyvsp[-2].valSTRING);
																(yyval.variable)->type = (yyvsp[-3].valINT);
																(yyval.variable)->is_const = 1;

																if((yyvsp[-3].valINT) == STRING){
																	(yyval.variable)->value.valSTRING = (char*)malloc((strlen((yyvsp[0].variable)->value.valSTRING) + 1) * sizeof(char));
																	strcpy((yyval.variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING);
																}
																else{
																	(yyval.variable)->value.valINT = 0;
																	memcpy(&(yyval.variable)->value, &(yyvsp[0].variable)->value, sizeof((yyvsp[0].variable)->value)); 
																}
															}

															(yyval.variable)->size = 0;
															free_const((yyvsp[0].variable));
														}
#line 2035 "y.tab.c"
    break;

  case 42:
#line 443 "limbaj.y"
                                                                                        {
															if(general_lookup((yyvsp[-2].valSTRING)) != NULL){
																free_stack_global();
																free_functions();
																free_const((yyvsp[0].variable));
																printf("Error at line: %d\n", yylineno);
																printf("The variable is already declared!!!\n");
																exit(1);
															}
															if((yyvsp[-3].valINT) != (yyvsp[0].variable)->type){
																free_stack_global();
																free_functions();
																free_const((yyvsp[0].variable));
																printf("eroare la linia:%d\n", yylineno);
																printf("The types are incompatible!!!\n");
        														exit(1);
															}

															if(strcmp((yyvsp[0].variable)->name, "@const") == 0){
																(yyval.variable) = (yyvsp[0].variable);
																(yyval.variable)->name = (yyvsp[-2].valSTRING);
																(yyval.variable)->is_const = 0;
															}
															else{
																(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
																(yyval.variable)->name = (yyvsp[-2].valSTRING);
																(yyval.variable)->type = (yyvsp[-3].valINT);
																(yyval.variable)->is_const = 0;

																if((yyvsp[-3].valINT) == STRING){
																	(yyval.variable)->value.valSTRING = (char*)malloc((strlen((yyvsp[0].variable)->value.valSTRING) + 1) * sizeof(char));
																	strcpy((yyval.variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING);
																}
																else{
																	(yyval.variable)->value.valINT = 0;
																	memcpy(&(yyval.variable)->value, &(yyvsp[0].variable)->value, sizeof((yyvsp[0].variable)->value)); 
																}
															}
															
															free_const((yyvsp[0].variable));
															(yyval.variable)->size = 0;
														}
#line 2082 "y.tab.c"
    break;

  case 43:
#line 485 "limbaj.y"
                                                                        {
														array_type = (yyvsp[-4].valINT);
														printf("aici\n");
													}
#line 2091 "y.tab.c"
    break;

  case 44:
#line 489 "limbaj.y"
                                                                                                                                                                {
																					if(general_lookup((yyvsp[-8].valSTRING)) != NULL){
																						free_stack_global();
																						free_functions();
																						printf("Error at line: %d\n", yylineno);
																						printf("The variable is already declared!!!\n");
																						exit(1);
																					}
																					

																					(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
																					(yyval.variable)->name = (yyvsp[-8].valSTRING);
																					(yyval.variable)->type = (yyvsp[-9].valINT);
																					(yyval.variable)->is_const = 1;			
																					(yyval.variable)->value.valINT = 0;
																					(yyval.variable)->size = (yyvsp[-6].valINT);
																					array_type = 0;
																				}
#line 2114 "y.tab.c"
    break;

  case 45:
#line 507 "limbaj.y"
                                                                        {
														array_type = (yyvsp[-4].valINT);
														printf("aici\n");
													}
#line 2123 "y.tab.c"
    break;

  case 46:
#line 511 "limbaj.y"
                                                                                                                                                                {
																					if(general_lookup((yyvsp[-8].valSTRING)) != NULL){
																						free_stack_global();
																						free_functions();
																						printf("Error at line: %d\n", yylineno);
																						printf("The variable is already declared!!!\n");
																						exit(1);
																					}
																					

																					(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
																					(yyval.variable)->name = (yyvsp[-8].valSTRING);
																					(yyval.variable)->type = (yyvsp[-9].valINT);
																					(yyval.variable)->is_const = 0;			
																					(yyval.variable)->value.valINT = 0;
																					(yyval.variable)->size = (yyvsp[-6].valINT);
																					array_type = 0;
																				}
#line 2146 "y.tab.c"
    break;

  case 47:
#line 532 "limbaj.y"
                                                                {
												if((yyvsp[-2].variable)->type != array_type){
													free_stack_global();
													free_functions();
													free_const((yyvsp[-2].variable));
													printf("Error at line: %d\n", yylineno);
													printf("The elements of the array are not as the same type as the array!!!\n");
													exit(1);
												}
											}
#line 2161 "y.tab.c"
    break;

  case 48:
#line 542 "limbaj.y"
                                                                        {
												if((yyvsp[0].variable)->type != array_type){
													free_stack_global();
													free_functions();
													free_const((yyvsp[0].variable));
													printf("Error at line: %d\n", yylineno);
													printf("The elements of the array are not as the same type as the array!!!\n");
													exit(1);
												}
											}
#line 2176 "y.tab.c"
    break;

  case 50:
#line 555 "limbaj.y"
                              {(yyval.valINT) = INT;}
#line 2182 "y.tab.c"
    break;

  case 51:
#line 556 "limbaj.y"
                                        {(yyval.valINT) = FLOAT;}
#line 2188 "y.tab.c"
    break;

  case 52:
#line 557 "limbaj.y"
                                         {(yyval.valINT) = STRING;}
#line 2194 "y.tab.c"
    break;

  case 53:
#line 558 "limbaj.y"
                                       {(yyval.valINT) = CHAR;}
#line 2200 "y.tab.c"
    break;

  case 54:
#line 559 "limbaj.y"
                                       {(yyval.valINT) = BOOL;}
#line 2206 "y.tab.c"
    break;

  case 55:
#line 567 "limbaj.y"
                                                {
									(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
									(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
									strcpy((yyval.variable)->name, "@const");
									(yyval.variable)->type = INT;
									(yyval.variable)->value.valINT = (yyvsp[0].valINT);
								}
#line 2218 "y.tab.c"
    break;

  case 56:
#line 574 "limbaj.y"
                                                {
									(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
									(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
									strcpy((yyval.variable)->name, "@const");
									(yyval.variable)->type = FLOAT;
									(yyval.variable)->value.valFLOAT = (yyvsp[0].valFLOAT);
								}
#line 2230 "y.tab.c"
    break;

  case 57:
#line 581 "limbaj.y"
                                                {
									(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
									(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
									strcpy((yyval.variable)->name, "@const");
									(yyval.variable)->type = STRING;
									(yyval.variable)->value.valSTRING = (char*)malloc((strlen((yyvsp[0].valSTRING)) - 1) * sizeof(char));
									(yyvsp[0].valSTRING)[strlen((yyvsp[0].valSTRING)) - 1] = '\0';
									strcpy((yyval.variable)->value.valSTRING, (yyvsp[0].valSTRING) + 1);
								}
#line 2244 "y.tab.c"
    break;

  case 58:
#line 590 "limbaj.y"
                                                {
									(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
									(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
									strcpy((yyval.variable)->name, "@const");
									(yyval.variable)->type = CHAR;
									(yyval.variable)->value.valCHAR = (yyvsp[0].valCHAR);
								}
#line 2256 "y.tab.c"
    break;

  case 59:
#line 597 "limbaj.y"
                                                {
									(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
									(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
									strcpy((yyval.variable)->name, "@const");
									(yyval.variable)->type = BOOL;
									(yyval.variable)->value.valBOOL = (yyvsp[0].valBOOL);
								}
#line 2268 "y.tab.c"
    break;

  case 63:
#line 611 "limbaj.y"
                                        {(yyval.valINT) = PLUSA;}
#line 2274 "y.tab.c"
    break;

  case 64:
#line 612 "limbaj.y"
                                                {(yyval.valINT) = MINUSA;}
#line 2280 "y.tab.c"
    break;

  case 65:
#line 613 "limbaj.y"
                                                {(yyval.valINT) = MULTA;}
#line 2286 "y.tab.c"
    break;

  case 66:
#line 614 "limbaj.y"
                                                {(yyval.valINT) = SLASHA;}
#line 2292 "y.tab.c"
    break;

  case 67:
#line 618 "limbaj.y"
                                                                {
												struct Variable* v = general_lookup((yyvsp[-2].valSTRING));

												if(v == NULL || v->is_const == 1){
													free_const((yyvsp[0].variable));
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared or is const!!!\n");
													exit(1);
												}

												if(v->type != (yyvsp[0].variable)->type){
													free_const((yyvsp[0].variable));
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The types are not compatible!!!\n");
													exit(1);
												}
											
												if(v->type == STRING){
													v->value.valSTRING = (char*)malloc((strlen((yyvsp[0].variable)->value.valSTRING) + 1) * sizeof(char));
													strcpy(v->value.valSTRING, (yyvsp[0].variable)->value.valSTRING);
												}
												else{
													v->value.valINT = 0;
													memcpy(&v->value, &(yyvsp[0].variable)->value, sizeof((yyvsp[0].variable)->value)); 
												}

												free_const((yyvsp[0].variable));
											}
#line 2329 "y.tab.c"
    break;

  case 69:
#line 651 "limbaj.y"
                                                                        {
												struct Variable* v = general_lookup((yyvsp[-1].valSTRING));

												if(v == NULL){
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared!!!\n");
													exit(1);
												}

												if((v->type != INT) && (v->type != CHAR) && (v->type != FLOAT) && (v->is_const == 1)){
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("Cannot increment this variable!!!\n");
													exit(1);
												}
												
												if(v->type == INT)
													++v->value.valINT;
												else if(v->type == FLOAT)
													++v->value.valFLOAT;
												else if(v->type == CHAR)
													++v->value.valCHAR;

											}
#line 2361 "y.tab.c"
    break;

  case 70:
#line 678 "limbaj.y"
                                                                        {
												struct Variable* v = general_lookup((yyvsp[-1].valSTRING));

												if(v == NULL){
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("The variable is not declared!!!\n");
													exit(1);
												}

												if((v->type != INT) && (v->type != CHAR) && (v->type != FLOAT) && (v->is_const == 1)){
													free_stack_global();
													free_functions();
													printf("Error at line: %d\n", yylineno);
													printf("Cannot decrement this variable!!!\n");
													exit(1);
												}
												
												if(v->type == INT)
													--v->value.valINT;
												else if(v->type == FLOAT)
													--v->value.valFLOAT;
												else if(v->type == CHAR)
													--v->value.valCHAR;

											}
#line 2393 "y.tab.c"
    break;

  case 71:
#line 708 "limbaj.y"
                                                                                {(yyval.variable) = (yyvsp[0].variable);}
#line 2399 "y.tab.c"
    break;

  case 72:
#line 709 "limbaj.y"
                                                                                {
													(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
													(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
													strcpy((yyval.variable)->name, "@const");
													(yyval.variable)->type = BOOL;
													(yyval.variable)->value.valBOOL = (yyvsp[0].valBOOL);
												}
#line 2411 "y.tab.c"
    break;

  case 73:
#line 716 "limbaj.y"
                                                                {
													int compatible = 1;
													(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
													(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
													strcpy((yyval.variable)->name, "@const");
													if((yyvsp[-2].variable)->type == INT && (yyvsp[0].variable)->type == INT){
														(yyval.variable)->type = INT;
														(yyval.variable)->value.valINT = (yyvsp[-2].variable)->value.valINT + (yyvsp[0].variable)->value.valINT;
													}
													else if((yyvsp[-2].variable)->type == FLOAT && (yyvsp[0].variable)->type == FLOAT){
														(yyval.variable)->type = FLOAT;
														(yyval.variable)->value.valFLOAT = (yyvsp[-2].variable)->value.valFLOAT + (yyvsp[0].variable)->value.valFLOAT;
													}
													else if((yyvsp[-2].variable)->type == STRING && (yyvsp[0].variable)->type == STRING){
														(yyval.variable)->type = STRING;
														int size = (strlen((yyvsp[-2].variable)->value.valSTRING) + strlen((yyvsp[0].variable)->value.valSTRING) + 1) * sizeof(char);
														(yyval.variable)->value.valSTRING = (char*)malloc(size);
														strcpy((yyval.variable)->value.valSTRING, (yyvsp[-2].variable)->value.valSTRING);
														strcat((yyval.variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING);
													}
													// else if($1->type == STRING && $3->type == CHAR){
													// 	$$->type = STRING;
													// 	int size = (strlen($1->value.valSTRING) + 2) * sizeof(char);
													// 	$$->value.valSTRING = (char*)malloc(size);
													// 	strcpy($$->value.valSTRING, $1->value.valSTRING);
													// 	$$->value.valSTRING[strlen($$->value.valSTRING) + 1] = '\0';
													// 	$$->value.valSTRING[strlen($$->value.valSTRING)] = $3->value.valCHAR;

													// }
													// else if($1->type == CHAR && $3->type == STRING){
													// 	$$->type = STRING;
													// 	int size = (strlen($3->value.valSTRING) + 2) * sizeof(char);
													// 	$$->value.valSTRING = (char*)malloc(size);
													// 	$$->value.valSTRING[1] = '\0';
													// 	$$->value.valSTRING[0] = $1->value.valCHAR;
													// 	strcat($$->value.valSTRING, $3->value.valSTRING);
													// }
													else{
														compatible = 0;
													}

													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be added!!!\n");
        												exit(1);
													}

												}
#line 2469 "y.tab.c"
    break;

  case 74:
#line 769 "limbaj.y"
                                                                {
													int compatible = 1;
													(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
													(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
													strcpy((yyval.variable)->name, "@const");
													if((yyvsp[-2].variable)->type == INT && (yyvsp[0].variable)->type == INT){
														(yyval.variable)->type = INT;
														(yyval.variable)->value.valINT = (yyvsp[-2].variable)->value.valINT - (yyvsp[0].variable)->value.valINT;
													}
													else if((yyvsp[-2].variable)->type == FLOAT && (yyvsp[0].variable)->type == FLOAT){
														(yyval.variable)->type = FLOAT;
														(yyval.variable)->value.valFLOAT = (yyvsp[-2].variable)->value.valFLOAT - (yyvsp[0].variable)->value.valFLOAT;
													}
													else{
														compatible = 0;
													}

													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be subtracted!!!\n");
        												exit(1);
													}
												}
#line 2502 "y.tab.c"
    break;

  case 75:
#line 797 "limbaj.y"
                                                                {
													int compatible = 1;
													(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
													(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
													strcpy((yyval.variable)->name, "@const");
													if(((yyvsp[-2].variable)->type == INT && (yyvsp[0].variable)->type == INT)){
														(yyval.variable)->type = INT;
														(yyval.variable)->value.valINT = ((yyvsp[-2].variable)->value.valINT / (yyvsp[0].variable)->value.valINT);
													}
													else if((yyvsp[-2].variable)->type == FLOAT && (yyvsp[0].variable)->type == FLOAT){
														(yyval.variable)->type = FLOAT;
														(yyval.variable)->value.valFLOAT = (yyvsp[-2].variable)->value.valFLOAT / (yyvsp[0].variable)->value.valFLOAT;
													}
													else{
														compatible = 0;
													}

													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be divided!!!\n");
        												exit(1);
													}
												}
#line 2535 "y.tab.c"
    break;

  case 76:
#line 825 "limbaj.y"
                                                                {
													int compatible = 1;
													(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
													(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
													strcpy((yyval.variable)->name, "@const");
													if((yyvsp[-2].variable)->type == INT && (yyvsp[0].variable)->type == INT){
														(yyval.variable)->type = INT;
														(yyval.variable)->value.valINT = (yyvsp[-2].variable)->value.valINT * (yyvsp[0].variable)->value.valINT;
													}
													else if((yyvsp[-2].variable)->type == FLOAT && (yyvsp[0].variable)->type == FLOAT){
														(yyval.variable)->type = FLOAT;
														(yyval.variable)->value.valFLOAT = (yyvsp[-2].variable)->value.valFLOAT * (yyvsp[0].variable)->value.valFLOAT;
													}
													// else if($1->type == STRING && $3->type == INT){
													// 	$$->type = STRING;
													// 	int size = ((strlen($1->value.valSTRING) * $3->value.valINT) + 1) * sizeof(char);
													// 	$$->value.valSTRING = (char*)malloc(size);
													// 	strcpy($$->value.valSTRING, $1->value.valSTRING);
														
													// 	for(int i = 1; i < $3->value.valINT; ++i)
													// 		strcat($$->value.valSTRING, $1->value.valSTRING);
													// }
													else{
														compatible = 0;
													}

													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be multiplyed!!!\n");
        												exit(1);
													}
												}
#line 2577 "y.tab.c"
    break;

  case 77:
#line 862 "limbaj.y"
                                                                 {
													int compatible = 1;
													(yyval.variable) = (struct Variable*)malloc(sizeof(struct Variable));
													(yyval.variable)->name = (char*)malloc(strlen("@const") + 1);
													strcpy((yyval.variable)->name, "@const");
													if(((yyvsp[-2].variable)->type == INT && (yyvsp[0].variable)->type == INT)){
														(yyval.variable)->type = INT;
														(yyval.variable)->value.valINT = (yyvsp[-2].variable)->value.valINT % (yyvsp[0].variable)->value.valINT;
													}
													else{
														compatible = 0;
													}

													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));

													if(compatible == 0){
														free_stack_global();
														free_functions();
														printf("Error at line: %d\n", yylineno);
														printf("These types can't be divided!!!\n");
        												exit(1);
													}
												}
#line 2606 "y.tab.c"
    break;

  case 78:
#line 886 "limbaj.y"
                                                                        { (yyval.variable) = (yyvsp[-1].variable);}
#line 2612 "y.tab.c"
    break;

  case 79:
#line 887 "limbaj.y"
                                                                                {
													if((yyvsp[0].variable)->type == -1){
														free_stack_global();
														free_functions();
														free_const((yyvsp[0].variable));
														printf("Error at line: %d\n", yylineno);
														printf("Procedures don't return any value!!!\n");
														exit(1);
													}

													(yyval.variable) = (yyvsp[0].variable);
												}
#line 2629 "y.tab.c"
    break;

  case 80:
#line 902 "limbaj.y"
                                                                                {(yyval.valBOOL) = (yyvsp[0].valBOOL);}
#line 2635 "y.tab.c"
    break;

  case 81:
#line 903 "limbaj.y"
                                                                                        {(yyval.valBOOL) = (yyvsp[-1].valBOOL);}
#line 2641 "y.tab.c"
    break;

  case 82:
#line 904 "limbaj.y"
                                                                                {(yyval.valBOOL) = (yyvsp[-2].valBOOL) && (yyvsp[0].valBOOL);}
#line 2647 "y.tab.c"
    break;

  case 83:
#line 905 "limbaj.y"
                                                                                {(yyval.valBOOL) = (yyvsp[-2].valBOOL) || (yyvsp[0].valBOOL);}
#line 2653 "y.tab.c"
    break;

  case 84:
#line 906 "limbaj.y"
                                                                                        {(yyval.valBOOL) = !(yyvsp[0].valBOOL);}
#line 2659 "y.tab.c"
    break;

  case 85:
#line 910 "limbaj.y"
                                                                                {
												if((yyvsp[0].variable)->type != BOOL){
													free_stack_global();
													free_functions();
													free_const((yyvsp[0].variable));
													printf("Error at line: %d\n", yylineno);
													printf("Thise variables is not of type bool!!!\n");
													exit(1);
												}

												(yyval.valBOOL) = (yyvsp[0].variable)->value.valBOOL;
												free_const((yyvsp[0].variable));
											}
#line 2677 "y.tab.c"
    break;

  case 86:
#line 923 "limbaj.y"
                                                                        {
												if((yyvsp[-2].variable)->type != (yyvsp[0].variable)->type){
													free_stack_global();
													free_functions();
													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if((yyvsp[-2].variable)->type == STRING)
													(yyval.valBOOL) = strcmp((yyvsp[-2].variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING) != 0;
												else
													(yyval.valBOOL) = ((yyvsp[-2].variable)->type == INT) ? (yyvsp[-2].variable)->value.valINT != (yyvsp[0].variable)->value.valINT 
														: ((yyvsp[-2].variable)->type == FLOAT) ? (yyvsp[-2].variable)->value.valFLOAT != (yyvsp[0].variable)->value.valFLOAT
														: ((yyvsp[-2].variable)->type == CHAR) ? (yyvsp[-2].variable)->value.valCHAR != (yyvsp[0].variable)->value.valCHAR
														: ((yyvsp[-2].variable)->type == BOOL) ? (yyvsp[-2].variable)->value.valBOOL != (yyvsp[0].variable)->value.valBOOL : 0;

												free_const((yyvsp[-2].variable));
												free_const((yyvsp[0].variable));
											}
#line 2704 "y.tab.c"
    break;

  case 87:
#line 945 "limbaj.y"
                                                                        {
												if((yyvsp[-2].variable)->type != (yyvsp[0].variable)->type){
													free_stack_global();
													free_functions();
													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if((yyvsp[-2].variable)->type == STRING)
													(yyval.valBOOL) = strcmp((yyvsp[-2].variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING) == 0;
												else
													(yyval.valBOOL) = ((yyvsp[-2].variable)->type == INT) ? (yyvsp[-2].variable)->value.valINT == (yyvsp[0].variable)->value.valINT 
														: ((yyvsp[-2].variable)->type == FLOAT) ? (yyvsp[-2].variable)->value.valFLOAT == (yyvsp[0].variable)->value.valFLOAT
														: ((yyvsp[-2].variable)->type == CHAR) ? (yyvsp[-2].variable)->value.valCHAR == (yyvsp[0].variable)->value.valCHAR
														: ((yyvsp[-2].variable)->type == BOOL) ? (yyvsp[-2].variable)->value.valBOOL == (yyvsp[0].variable)->value.valBOOL : 0;

												free_const((yyvsp[-2].variable));
												free_const((yyvsp[0].variable));
											}
#line 2731 "y.tab.c"
    break;

  case 88:
#line 968 "limbaj.y"
                                                                        {
												if((yyvsp[-2].variable)->type != (yyvsp[0].variable)->type){
													
													free_stack_global();
													free_functions();
													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if((yyvsp[-2].variable)->type == STRING)
													(yyval.valBOOL) = strcmp((yyvsp[-2].variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING) < 0;
												else
													(yyval.valBOOL) = ((yyvsp[-2].variable)->type == INT) ? (yyvsp[-2].variable)->value.valINT < (yyvsp[0].variable)->value.valINT 
														: ((yyvsp[-2].variable)->type == FLOAT) ? (yyvsp[-2].variable)->value.valFLOAT < (yyvsp[0].variable)->value.valFLOAT
														: ((yyvsp[-2].variable)->type == CHAR) ? (yyvsp[-2].variable)->value.valCHAR < (yyvsp[0].variable)->value.valCHAR
														: ((yyvsp[-2].variable)->type == BOOL) ? (yyvsp[-2].variable)->value.valBOOL < (yyvsp[0].variable)->value.valBOOL : 0;

												free_const((yyvsp[-2].variable));
												free_const((yyvsp[0].variable));
											}
#line 2759 "y.tab.c"
    break;

  case 89:
#line 991 "limbaj.y"
                                                                {
												if((yyvsp[-2].variable)->type != (yyvsp[0].variable)->type){
													free_stack_global();
													free_functions();
													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if((yyvsp[-2].variable)->type == STRING)
													(yyval.valBOOL) = strcmp((yyvsp[-2].variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING) <= 0;
												else
													(yyval.valBOOL) = ((yyvsp[-2].variable)->type == INT) ? (yyvsp[-2].variable)->value.valINT <= (yyvsp[0].variable)->value.valINT 
														: ((yyvsp[-2].variable)->type == FLOAT) ? (yyvsp[-2].variable)->value.valFLOAT <= (yyvsp[0].variable)->value.valFLOAT
														: ((yyvsp[-2].variable)->type == CHAR) ? (yyvsp[-2].variable)->value.valCHAR <= (yyvsp[0].variable)->value.valCHAR
														: ((yyvsp[-2].variable)->type == BOOL) ? (yyvsp[-2].variable)->value.valBOOL <= (yyvsp[0].variable)->value.valBOOL : 0;

												free_const((yyvsp[-2].variable));
												free_const((yyvsp[0].variable));
											}
#line 2786 "y.tab.c"
    break;

  case 90:
#line 1013 "limbaj.y"
                                                                        {
												if((yyvsp[-2].variable)->type != (yyvsp[0].variable)->type){
													free_stack_global();
													free_functions();
													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if((yyvsp[-2].variable)->type == STRING)
													(yyval.valBOOL) = strcmp((yyvsp[-2].variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING) > 0;
												else
													(yyval.valBOOL) = ((yyvsp[-2].variable)->type == INT) ? (yyvsp[-2].variable)->value.valINT > (yyvsp[0].variable)->value.valINT 
														: ((yyvsp[-2].variable)->type == FLOAT) ? (yyvsp[-2].variable)->value.valFLOAT > (yyvsp[0].variable)->value.valFLOAT
														: ((yyvsp[-2].variable)->type == CHAR) ? (yyvsp[-2].variable)->value.valCHAR > (yyvsp[0].variable)->value.valCHAR
														: ((yyvsp[-2].variable)->type == BOOL) ? (yyvsp[-2].variable)->value.valBOOL > (yyvsp[0].variable)->value.valBOOL : 0;

												free_const((yyvsp[-2].variable));
												free_const((yyvsp[0].variable));
											}
#line 2813 "y.tab.c"
    break;

  case 91:
#line 1035 "limbaj.y"
                                                                {
												if((yyvsp[-2].variable)->type != (yyvsp[0].variable)->type){
													free_stack_global();
													free_functions();
													free_const((yyvsp[-2].variable));
													free_const((yyvsp[0].variable));
													printf("Error at line: %d\n", yylineno);
													printf("These types can't be compared!!!\n");
													exit(1);
												}

												if((yyvsp[-2].variable)->type == STRING)
													(yyval.valBOOL) = strcmp((yyvsp[-2].variable)->value.valSTRING, (yyvsp[0].variable)->value.valSTRING) >= 0;
												else
													(yyval.valBOOL) = ((yyvsp[-2].variable)->type == INT) ? (yyvsp[-2].variable)->value.valINT >= (yyvsp[0].variable)->value.valINT 
														: ((yyvsp[-2].variable)->type == FLOAT) ? (yyvsp[-2].variable)->value.valFLOAT >= (yyvsp[0].variable)->value.valFLOAT
														: ((yyvsp[-2].variable)->type == CHAR) ? (yyvsp[-2].variable)->value.valCHAR >= (yyvsp[0].variable)->value.valCHAR
														: ((yyvsp[-2].variable)->type == BOOL) ? (yyvsp[-2].variable)->value.valBOOL >= (yyvsp[0].variable)->value.valBOOL : 0;

												free_const((yyvsp[-2].variable));
												free_const((yyvsp[0].variable));
											}
#line 2840 "y.tab.c"
    break;

  case 92:
#line 1060 "limbaj.y"
                                   {
						(yyval.variable) = general_lookup((yyvsp[0].valSTRING));
						free((yyvsp[0].valSTRING));
						if((yyval.variable) == NULL){
							free_stack_global();
							free_functions();
							printf("Error at line: %d\n", yylineno);
							printf("The variable is not declared!!!\n");
							exit(1);
						}
					}
#line 2856 "y.tab.c"
    break;

  case 94:
#line 1075 "limbaj.y"
                                                       {push(stack_scope[curr_pos]);}
#line 2862 "y.tab.c"
    break;

  case 95:
#line 1075 "limbaj.y"
                                                                                                             { 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									 }
#line 2871 "y.tab.c"
    break;

  case 96:
#line 1081 "limbaj.y"
                                                                                           {push(stack_scope[curr_pos]);}
#line 2877 "y.tab.c"
    break;

  case 97:
#line 1081 "limbaj.y"
                                                                                                                                                { 	
																																	struct Node* n = pop(stack_scope[curr_pos]);
																																	delete_list(&n);
																																}
#line 2886 "y.tab.c"
    break;

  case 98:
#line 1085 "limbaj.y"
                                                                                           {push(stack_scope[curr_pos]);}
#line 2892 "y.tab.c"
    break;

  case 99:
#line 1085 "limbaj.y"
                                                                                                                                                { 	
																																	struct Node* n = pop(stack_scope[curr_pos]);
																																	delete_list(&n);
																																}
#line 2901 "y.tab.c"
    break;

  case 100:
#line 1091 "limbaj.y"
                                                            {push(stack_scope[curr_pos]);}
#line 2907 "y.tab.c"
    break;

  case 101:
#line 1091 "limbaj.y"
                                                                                                                        { 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									}
#line 2916 "y.tab.c"
    break;

  case 102:
#line 1095 "limbaj.y"
                                                            {push(stack_scope[curr_pos]);}
#line 2922 "y.tab.c"
    break;

  case 103:
#line 1095 "limbaj.y"
                                                                                                                        { 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									}
#line 2931 "y.tab.c"
    break;

  case 104:
#line 1099 "limbaj.y"
                                                                                                                                                                                                             {push(stack_scope[curr_pos]);}
#line 2937 "y.tab.c"
    break;

  case 105:
#line 1100 "limbaj.y"
                                                                                                                                                                                                        { 	
																										struct Node* n = pop(stack_scope[curr_pos]);
																										delete_list(&n);
																									}
#line 2946 "y.tab.c"
    break;


#line 2950 "y.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 1105 "limbaj.y"


void free_const(struct Variable* v){
	if(strcmp(v->name, "@const") == 0){
		if(v->type == STRING)
			free(v->value.valSTRING);
		free(v->name);
		free(v);
	}
}

void delete_list(struct Node **head)
{
	struct Node *current = *head;
	while (current != NULL)
	{
		struct Node *temp = current;
		current = current->next;
		if(temp->variable->type == STRING)
			free(temp->variable->value.valSTRING);
		free(temp->variable->name);
		free(temp->variable);
		free(temp);
	}
	*head = NULL;
}

void write_to_file(Variable* var)
{
    FILE* fp = fopen("symbol_table.txt", "a");
    if (fp == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }

    fprintf(fp, "Variable name: %s,", var->name);
    switch (var->type)
    {
        case INT:
            fprintf(fp, "Type: int, Value: %d, ", var->value.valINT);
            break;
        case FLOAT:
            fprintf(fp, "Type: float, Value: %f", var->value.valFLOAT);
            break;
        case CHAR:
            fprintf(fp, "Type: char, Value: %c", var->value.valCHAR);
            break;
        case STRING:
            fprintf(fp, "Type: string, Value: %s", var->value.valSTRING);
            break;
        case BOOL:
            fprintf(fp, "Type: bool, Value: %d", var->value.valBOOL);
            break;
        default:
            printf("Invalid type!\n");
            exit(1);
    }

	fprintf(fp, "\n");

    fclose(fp);
}

void write_function_to_file(Function* func)
{
    FILE* fp = fopen("symbol_table_functions.txt", "a");
    if (fp == NULL)
    {
        printf("Error opening file!\n");
        exit(1);
    }

    fprintf(fp, "Function name: %s, ", func->name);
	switch (func->return_type)
    {
        case INT:
            fprintf(fp, "Return type: int, ");
            break;
        case FLOAT:
            fprintf(fp, "Return type: float, ");
            break;
        case CHAR:
            fprintf(fp, "Return type: char, ");
            break;
        case STRING:
            fprintf(fp, "Return type: string, ");
            break;
        case BOOL:
            fprintf(fp, "Return type: bool, ");
            break;
        default:
            fprintf(fp, "Return type: void, ");
    }

	fprintf(fp, "Parameters: ");

    for (int i = func->nr_parameters-1; i >= 0; i--)
    {
		//printf("%s\n", func->parameters_name[i]);
		fprintf(fp, "Parameter name: %s, ", func->parameters_name[i]);
        switch (func->parameters[i])
		{
			case INT:
				fprintf(fp, "Parameter type: int. ");
				break;
			case FLOAT:
				fprintf(fp, "Parameter type: float. ");
				break;
			case CHAR:
				fprintf(fp, "Parameter type: char. ");
				break;
			case STRING:
				fprintf(fp, "Parameter type: string. ");
				break;
			case BOOL:
				fprintf(fp, "Parameter type: bool. ");
				break;
			default:
				printf("Invalid type!\n");
				exit(1);
		}
    }
    fprintf(fp, "\n");

    fclose(fp);
}

int yyerror(char * s){
	printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
	yyin=fopen(argv[1],"r");
	yyparse();
} 
