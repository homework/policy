
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 1 "gram.y"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "util.h"
#include "timestamp.h"
#include "sqlstmts.h"
#include "list.h"
#include "typetable.h"
#include "mem.h"

extern int yylex();

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
}

/* SQL statement to be returned after parsing */
extern sqlstmt stmt;

/* Temporary lists used while parsing */

/* Select */
List *clist;
List *cattriblist;
List *tlist;
List *flist;
List *wlist;
List *plist; /* pair list */
sqlwindow *tmpwin;
int tmpunit;
sqlfilter *tmpfilter;
sqlpair *tmppair;
int tmpvaltype;
char *tmpvalstr;
int filtertype;
char *orderby;
int countstar;
List *grouplist;
sqlinterval tmpinterval;

/* Create */
char *tablename;
List *colnames;
List *coltypes;
short tabletype;
short primary_column;
short column;

/* Insert */
/* -- tablename definition from above */
/* -- coltypes definition from above */
List *colvals;
short transform;



/* Line 189 of yacc.c  */
#line 138 "y.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     NUMFLOAT = 259,
     TSTAMP = 260,
     DATESTRING = 261,
     WORD = 262,
     QUOTEDSTRING = 263,
     IPADDR = 264,
     SELECT = 265,
     FROM = 266,
     WHERE = 267,
     LESSEQ = 268,
     GREATEREQ = 269,
     LESS = 270,
     GREATER = 271,
     EQUALS = 272,
     COMMA = 273,
     STAR = 274,
     SEMICOLON = 275,
     CREATE = 276,
     INSERT = 277,
     TABLETK = 278,
     OPENBRKT = 279,
     CLOSEBRKT = 280,
     TABLE = 281,
     INTO = 282,
     VALUES = 283,
     BOOLEAN = 284,
     INTEGER = 285,
     REAL = 286,
     CHARACTER = 287,
     VARCHAR = 288,
     BLOB = 289,
     TINYINT = 290,
     SMALLINT = 291,
     TRUETK = 292,
     FALSETK = 293,
     SINGLEQUOTE = 294,
     PRIMARY = 295,
     KEY = 296,
     OPENSQBRKT = 297,
     CLOSESQBRKT = 298,
     MILLIS = 299,
     SECONDS = 300,
     MINUTES = 301,
     HOURS = 302,
     RANGE = 303,
     SINCE = 304,
     INTERVAL = 305,
     NOW = 306,
     ROWS = 307,
     LAST = 308,
     SHOW = 309,
     TABLES = 310,
     AND = 311,
     OR = 312,
     SAVE = 313,
     AS = 314,
     EXEC = 315,
     DELETE = 316,
     QUERY = 317,
     COUNT = 318,
     MIN = 319,
     MAX = 320,
     AVG = 321,
     SUM = 322,
     ORDER = 323,
     BY = 324,
     PUBLISH = 325,
     SUBSCRIBE = 326,
     UNSUBSCRIBE = 327,
     REGISTER = 328,
     UNREGISTER = 329,
     PERSISTENTTABLETK = 330,
     GROUP = 331,
     UPDATE = 332,
     SET = 333,
     ADD = 334,
     SUB = 335,
     ON = 336,
     DUPLICATETK = 337,
     CONTAINS = 338,
     NOTCONTAINS = 339
   };
#endif
/* Tokens.  */
#define NUMBER 258
#define NUMFLOAT 259
#define TSTAMP 260
#define DATESTRING 261
#define WORD 262
#define QUOTEDSTRING 263
#define IPADDR 264
#define SELECT 265
#define FROM 266
#define WHERE 267
#define LESSEQ 268
#define GREATEREQ 269
#define LESS 270
#define GREATER 271
#define EQUALS 272
#define COMMA 273
#define STAR 274
#define SEMICOLON 275
#define CREATE 276
#define INSERT 277
#define TABLETK 278
#define OPENBRKT 279
#define CLOSEBRKT 280
#define TABLE 281
#define INTO 282
#define VALUES 283
#define BOOLEAN 284
#define INTEGER 285
#define REAL 286
#define CHARACTER 287
#define VARCHAR 288
#define BLOB 289
#define TINYINT 290
#define SMALLINT 291
#define TRUETK 292
#define FALSETK 293
#define SINGLEQUOTE 294
#define PRIMARY 295
#define KEY 296
#define OPENSQBRKT 297
#define CLOSESQBRKT 298
#define MILLIS 299
#define SECONDS 300
#define MINUTES 301
#define HOURS 302
#define RANGE 303
#define SINCE 304
#define INTERVAL 305
#define NOW 306
#define ROWS 307
#define LAST 308
#define SHOW 309
#define TABLES 310
#define AND 311
#define OR 312
#define SAVE 313
#define AS 314
#define EXEC 315
#define DELETE 316
#define QUERY 317
#define COUNT 318
#define MIN 319
#define MAX 320
#define AVG 321
#define SUM 322
#define ORDER 323
#define BY 324
#define PUBLISH 325
#define SUBSCRIBE 326
#define UNSUBSCRIBE 327
#define REGISTER 328
#define UNREGISTER 329
#define PERSISTENTTABLETK 330
#define GROUP 331
#define UPDATE 332
#define SET 333
#define ADD 334
#define SUB 335
#define ON 336
#define DUPLICATETK 337
#define CONTAINS 338
#define NOTCONTAINS 339




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 66 "gram.y"

    long long number;
    double numfloat;
    char character;
    char *string;
    unsigned long long tstamp;



/* Line 214 of yacc.c  */
#line 352 "y.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 364 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

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
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
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
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
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
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  45
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   251

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  85
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  33
/* YYNRULES -- Number of rules.  */
#define YYNRULES  111
/* YYNRULES -- Number of states.  */
#define YYNSTATES  249

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   339

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
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
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     7,    10,    14,    21,    23,    25,
      27,    29,    32,    35,    41,    47,    53,    56,    61,    68,
      76,    86,    91,    98,   106,   116,   124,   134,   147,   149,
     153,   155,   160,   165,   170,   175,   177,   182,   184,   188,
     190,   195,   197,   199,   201,   205,   208,   211,   213,   215,
     221,   227,   233,   239,   241,   243,   245,   247,   250,   252,
     254,   258,   262,   264,   268,   272,   276,   280,   284,   288,
     292,   296,   300,   304,   308,   310,   312,   314,   316,   318,
     320,   324,   326,   327,   335,   337,   339,   341,   345,   349,
     353,   357,   361,   368,   375,   379,   383,   387,   388,   391,
     399,   411,   418,   420,   424,   428,   432,   436,   440,   444,
     448,   450
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      86,     0,    -1,    87,    -1,     1,    -1,    60,     7,    -1,
      61,    62,     7,    -1,    58,    24,    88,    25,    59,     7,
      -1,    88,    -1,   108,    -1,   114,    -1,   115,    -1,    54,
      55,    -1,    70,     7,    -1,    71,     7,     9,     3,     7,
      -1,    72,     7,     9,     3,     7,    -1,    73,     8,     9,
       3,     7,    -1,    74,     3,    -1,    10,    91,    11,    92,
      -1,    10,    91,    11,    92,    12,   100,    -1,    10,    91,
      11,    92,    68,    69,   105,    -1,    10,    91,    11,    92,
      12,   100,    68,    69,   105,    -1,    10,    89,    11,    92,
      -1,    10,    89,    11,    92,    12,   100,    -1,    10,    89,
      11,    92,    68,    69,   105,    -1,    10,    89,    11,    92,
      12,   100,    68,    69,   105,    -1,    10,    89,    11,    92,
      76,    69,   106,    -1,    10,    89,    11,    92,    12,   100,
      76,    69,   106,    -1,    10,    89,    11,    92,    12,   100,
      76,    69,   106,    68,    69,   105,    -1,    90,    -1,    89,
      18,    90,    -1,     7,    -1,    64,    24,     7,    25,    -1,
      65,    24,     7,    25,    -1,    66,    24,     7,    25,    -1,
      67,    24,     7,    25,    -1,    19,    -1,    63,    24,    19,
      25,    -1,    93,    -1,    92,    18,    93,    -1,     7,    -1,
       7,    42,    94,    43,    -1,    95,    -1,    99,    -1,    51,
      -1,    48,     3,    98,    -1,    49,    96,    -1,    50,    97,
      -1,     5,    -1,     6,    -1,    24,    96,    18,    96,    25,
      -1,    24,    96,    18,    96,    43,    -1,    42,    96,    18,
      96,    25,    -1,    42,    96,    18,    96,    43,    -1,    44,
      -1,    45,    -1,    46,    -1,    47,    -1,    52,     3,    -1,
      53,    -1,   103,    -1,   100,    56,   103,    -1,   100,    57,
     103,    -1,   102,    -1,   101,    18,   102,    -1,     7,    17,
     104,    -1,     7,    79,   104,    -1,     7,    80,   104,    -1,
       7,    17,   104,    -1,     7,    15,   104,    -1,     7,    16,
     104,    -1,     7,    13,   104,    -1,     7,    14,   104,    -1,
       7,    83,   104,    -1,     7,    84,   104,    -1,     3,    -1,
       4,    -1,    96,    -1,     8,    -1,     7,    -1,   107,    -1,
     106,    18,   107,    -1,     7,    -1,    -1,    21,   110,     7,
     109,    24,   111,    25,    -1,    23,    -1,    75,    -1,   112,
      -1,   111,    18,   112,    -1,     7,    29,   113,    -1,     7,
      30,   113,    -1,     7,    31,   113,    -1,     7,    32,   113,
      -1,     7,    33,    24,     3,    25,   113,    -1,     7,    34,
      24,     3,    25,   113,    -1,     7,    35,   113,    -1,     7,
      36,   113,    -1,     7,     5,   113,    -1,    -1,    40,    41,
      -1,    22,    27,     7,    28,    24,   116,    25,    -1,    22,
      27,     7,    28,    24,   116,    25,    81,    82,    41,    77,
      -1,    77,     7,    78,   101,    12,   100,    -1,   117,    -1,
     116,    18,   117,    -1,    39,    37,    39,    -1,    39,    38,
      39,    -1,    39,     3,    39,    -1,    39,     4,    39,    -1,
      39,     5,    39,    -1,    39,     7,    39,    -1,     8,    -1,
       1,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   105,   105,   108,   113,   118,   123,   181,   246,   262,
     277,   298,   304,   312,   322,   332,   342,   351,   352,   353,
     354,   355,   356,   357,   358,   359,   360,   362,   367,   368,
     372,   392,   403,   414,   425,   439,   449,   462,   463,   467,
     479,   493,   494,   498,   502,   508,   513,   520,   524,   534,
     542,   550,   558,   569,   573,   577,   581,   588,   594,   601,
     602,   606,   613,   614,   620,   628,   636,   647,   657,   667,
     677,   687,   697,   706,   717,   721,   725,   729,   744,   751,
     752,   756,   764,   764,   771,   776,   784,   785,   789,   801,
     813,   825,   837,   851,   863,   875,   887,   902,   904,   918,
     923,   931,   938,   939,   943,   954,   965,   976,   987,   998,
    1009,  1025
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "NUMBER", "NUMFLOAT", "TSTAMP",
  "DATESTRING", "WORD", "QUOTEDSTRING", "IPADDR", "SELECT", "FROM",
  "WHERE", "LESSEQ", "GREATEREQ", "LESS", "GREATER", "EQUALS", "COMMA",
  "STAR", "SEMICOLON", "CREATE", "INSERT", "TABLETK", "OPENBRKT",
  "CLOSEBRKT", "TABLE", "INTO", "VALUES", "BOOLEAN", "INTEGER", "REAL",
  "CHARACTER", "VARCHAR", "BLOB", "TINYINT", "SMALLINT", "TRUETK",
  "FALSETK", "SINGLEQUOTE", "PRIMARY", "KEY", "OPENSQBRKT", "CLOSESQBRKT",
  "MILLIS", "SECONDS", "MINUTES", "HOURS", "RANGE", "SINCE", "INTERVAL",
  "NOW", "ROWS", "LAST", "SHOW", "TABLES", "AND", "OR", "SAVE", "AS",
  "EXEC", "DELETE", "QUERY", "COUNT", "MIN", "MAX", "AVG", "SUM", "ORDER",
  "BY", "PUBLISH", "SUBSCRIBE", "UNSUBSCRIBE", "REGISTER", "UNREGISTER",
  "PERSISTENTTABLETK", "GROUP", "UPDATE", "SET", "ADD", "SUB", "ON",
  "DUPLICATETK", "CONTAINS", "NOTCONTAINS", "$accept", "top", "sqlStmt",
  "selectStmt", "colList", "col", "all", "tableList", "table", "window",
  "timewindow", "tstamp_expression", "interval_expression", "unit",
  "tplwindow", "filterList", "pairList", "pair", "filter", "constant",
  "orderList", "groupList", "groupcol", "createStmt", "$@1", "tabDecl",
  "varDecls", "varDec", "SQLattrib", "insertStmt", "updateStmt", "valList",
  "val", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    85,    86,    86,    87,    87,    87,    87,    87,    87,
      87,    87,    87,    87,    87,    87,    87,    88,    88,    88,
      88,    88,    88,    88,    88,    88,    88,    88,    89,    89,
      90,    90,    90,    90,    90,    91,    91,    92,    92,    93,
      93,    94,    94,    95,    95,    95,    95,    96,    96,    97,
      97,    97,    97,    98,    98,    98,    98,    99,    99,   100,
     100,   100,   101,   101,   102,   102,   102,   103,   103,   103,
     103,   103,   103,   103,   104,   104,   104,   104,   105,   106,
     106,   107,   109,   108,   110,   110,   111,   111,   112,   112,
     112,   112,   112,   112,   112,   112,   112,   113,   113,   114,
     114,   115,   116,   116,   117,   117,   117,   117,   117,   117,
     117,   117
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     1,     2,     3,     6,     1,     1,     1,
       1,     2,     2,     5,     5,     5,     2,     4,     6,     7,
       9,     4,     6,     7,     9,     7,     9,    12,     1,     3,
       1,     4,     4,     4,     4,     1,     4,     1,     3,     1,
       4,     1,     1,     1,     3,     2,     2,     1,     1,     5,
       5,     5,     5,     1,     1,     1,     1,     2,     1,     1,
       3,     3,     1,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     3,     3,     1,     1,     1,     1,     1,     1,
       3,     1,     0,     7,     1,     1,     1,     3,     3,     3,
       3,     3,     6,     6,     3,     3,     3,     0,     2,     7,
      11,     6,     1,     3,     3,     3,     3,     3,     3,     3,
       1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     3,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     2,     7,     8,     9,
      10,    30,    35,     0,     0,     0,     0,     0,     0,    28,
       0,    84,    85,     0,     0,    11,     0,     4,     0,    12,
       0,     0,     0,    16,     0,     1,     0,     0,     0,     0,
       0,     0,     0,     0,    82,     0,     0,     5,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    39,    21,    37,
      29,    17,     0,     0,     0,     0,     0,     0,     0,     0,
      62,    36,    31,    32,    33,    34,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    13,    14,    15,     0,
       0,     0,     0,     0,     0,     0,     0,    43,     0,    58,
       0,    41,    42,     0,    22,    59,    38,     0,     0,    18,
       0,     0,     0,    86,   111,   110,     0,     0,   102,     6,
      74,    75,    47,    48,    77,    76,    64,    65,    66,   101,
      63,     0,    45,     0,     0,    46,    57,    40,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    78,
      23,    81,    25,    79,     0,    19,    97,    97,    97,    97,
      97,     0,     0,    97,    97,     0,    83,     0,     0,     0,
       0,     0,     0,     0,    99,    53,    54,    55,    56,    44,
       0,     0,    70,    71,    68,    69,    67,    72,    73,    60,
      61,     0,     0,     0,     0,     0,    96,    88,    89,    90,
      91,     0,     0,    94,    95,    87,   106,   107,   108,   109,
     104,   105,   103,     0,     0,     0,    24,    26,    80,    20,
      98,     0,     0,     0,     0,     0,     0,    97,    97,     0,
      49,    50,    51,    52,     0,    92,    93,   100,    27
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    15,    16,    17,    28,    29,    30,    68,    69,   110,
     111,   135,   145,   189,   112,   114,    79,    80,   115,   136,
     160,   162,   163,    18,    72,    33,   122,   123,   206,    19,
      20,   127,   128
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -162
static const yytype_int16 yypact[] =
{
       1,  -162,    24,   -18,    -6,   -26,    10,    47,   -10,    60,
      72,   101,   104,   111,   112,   117,  -162,  -162,  -162,  -162,
    -162,  -162,  -162,    94,    98,    99,   127,   129,    45,  -162,
     124,  -162,  -162,   145,   147,  -162,   146,  -162,   148,  -162,
     149,   150,   151,  -162,    79,  -162,   142,   155,   156,   157,
     158,   159,    28,   159,  -162,   139,   143,  -162,   166,   167,
     168,   165,   152,   153,   154,   160,   161,   131,    -8,  -162,
    -162,    12,   163,   164,   115,   169,   173,   174,   -14,    26,
    -162,  -162,  -162,  -162,  -162,  -162,    77,   175,   159,   106,
     114,   175,   120,   177,    19,   183,  -162,  -162,  -162,   128,
     128,   128,   175,   165,   188,    64,     4,  -162,   189,  -162,
     162,  -162,  -162,     2,   -31,  -162,  -162,   186,   187,   -15,
     186,   110,    88,  -162,  -162,  -162,   100,    91,  -162,  -162,
    -162,  -162,  -162,  -162,  -162,  -162,  -162,  -162,  -162,    54,
    -162,   103,  -162,    64,    64,  -162,  -162,  -162,   128,   128,
     128,   128,   128,   128,   128,   175,   175,   126,   130,  -162,
    -162,  -162,   178,  -162,   132,  -162,   170,   170,   170,   170,
     170,   176,   179,   170,   170,   177,  -162,   172,   180,   181,
     182,   184,   185,    19,   116,  -162,  -162,  -162,  -162,  -162,
     190,   191,  -162,  -162,  -162,  -162,  -162,  -162,  -162,  -162,
    -162,   186,   187,   187,   186,   171,  -162,  -162,  -162,  -162,
    -162,   195,   199,  -162,  -162,  -162,  -162,  -162,  -162,  -162,
    -162,  -162,  -162,   122,    64,    64,  -162,    -4,  -162,  -162,
    -162,   192,   193,   194,     7,     8,   137,   170,   170,   136,
    -162,  -162,  -162,  -162,   186,  -162,  -162,  -162,  -162
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -162,  -162,  -162,   196,  -162,   197,  -162,   198,   119,  -162,
    -162,  -104,  -162,  -162,  -162,   -55,  -162,   113,   -73,   -52,
    -120,    13,    11,  -162,  -162,  -162,  -162,    50,  -161,  -162,
    -162,  -162,    39
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
     165,   142,     1,    99,    87,    31,   207,   208,   209,   210,
      88,     2,   213,   214,   203,   148,   149,   150,   151,   152,
     124,    34,     3,     4,    91,   155,   156,   125,   143,    35,
      88,    21,   240,   242,    36,    21,   119,   157,   102,   190,
     191,   155,   156,    22,   103,   158,   144,   139,   137,   138,
     241,   243,    38,   164,    37,     5,    51,    32,   126,     6,
      89,     7,     8,    52,   236,   100,   101,    39,    90,   132,
     133,     9,    10,    11,    12,    13,   245,   246,    14,    40,
      92,   226,   199,   200,   229,   153,   154,    23,    24,    25,
      26,    27,    24,    25,    26,    27,   192,   193,   194,   195,
     196,   197,   198,   177,   178,   179,   175,   180,    41,   183,
     155,   156,    42,   176,    43,   166,   184,    45,    46,    44,
     234,   235,    47,    48,   248,   104,   105,   106,   107,   108,
     109,   130,   131,   132,   133,    53,   134,   181,   182,   167,
     168,   169,   170,   171,   172,   173,   174,   185,   186,   187,
     188,    49,    54,    50,    55,    57,     2,    61,    58,    59,
      60,    62,    63,    64,    65,    66,    67,    73,    74,    75,
      76,    77,    78,    86,    95,   117,    96,    81,    82,    83,
      97,    98,   113,   118,   121,    84,    85,    93,    94,   120,
     129,   141,   146,   159,   161,   201,   203,   223,   231,   202,
     211,   204,   232,   212,   233,   147,   244,   116,   224,   225,
     205,   216,   230,   247,   228,   227,   140,   237,   238,   217,
     218,   219,   222,   220,   221,   215,     0,     0,     0,     0,
       0,     0,    56,     0,     0,   239,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    70,
       0,    71
};

static const yytype_int16 yycheck[] =
{
     120,   105,     1,    17,    12,    23,   167,   168,   169,   170,
      18,    10,   173,   174,    18,    13,    14,    15,    16,    17,
       1,    27,    21,    22,    12,    56,    57,     8,    24,    55,
      18,     7,    25,    25,    24,     7,    91,    68,    12,   143,
     144,    56,    57,    19,    18,    76,    42,   102,   100,   101,
      43,    43,    62,    68,     7,    54,    11,    75,    39,    58,
      68,    60,    61,    18,    68,    79,    80,     7,    76,     5,
       6,    70,    71,    72,    73,    74,   237,   238,    77,     7,
      68,   201,   155,   156,   204,    83,    84,    63,    64,    65,
      66,    67,    64,    65,    66,    67,   148,   149,   150,   151,
     152,   153,   154,     3,     4,     5,    18,     7,     7,    18,
      56,    57,     8,    25,     3,     5,    25,     0,    24,     7,
     224,   225,    24,    24,   244,    48,    49,    50,    51,    52,
      53,     3,     4,     5,     6,    11,     8,    37,    38,    29,
      30,    31,    32,    33,    34,    35,    36,    44,    45,    46,
      47,    24,     7,    24,     7,     7,    10,    78,     9,     9,
       9,    19,     7,     7,     7,     7,     7,    28,    25,     3,
       3,     3,     7,    42,    59,    69,     7,    25,    25,    25,
       7,     7,     7,    69,     7,    25,    25,    24,    24,    69,
       7,     3,     3,     7,     7,    69,    18,    81,     3,    69,
      24,    69,     3,    24,    82,    43,    69,    88,    18,    18,
      40,    39,    41,    77,   203,   202,   103,    25,    25,    39,
      39,    39,   183,    39,    39,   175,    -1,    -1,    -1,    -1,
      -1,    -1,    36,    -1,    -1,    41,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    52,
      -1,    53
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     1,    10,    21,    22,    54,    58,    60,    61,    70,
      71,    72,    73,    74,    77,    86,    87,    88,   108,   114,
     115,     7,    19,    63,    64,    65,    66,    67,    89,    90,
      91,    23,    75,   110,    27,    55,    24,     7,    62,     7,
       7,     7,     8,     3,     7,     0,    24,    24,    24,    24,
      24,    11,    18,    11,     7,     7,    88,     7,     9,     9,
       9,    78,    19,     7,     7,     7,     7,     7,    92,    93,
      90,    92,   109,    28,    25,     3,     3,     3,     7,   101,
     102,    25,    25,    25,    25,    25,    42,    12,    18,    68,
      76,    12,    68,    24,    24,    59,     7,     7,     7,    17,
      79,    80,    12,    18,    48,    49,    50,    51,    52,    53,
      94,    95,    99,     7,   100,   103,    93,    69,    69,   100,
      69,     7,   111,   112,     1,     8,    39,   116,   117,     7,
       3,     4,     5,     6,     8,    96,   104,   104,   104,   100,
     102,     3,    96,    24,    42,    97,     3,    43,    13,    14,
      15,    16,    17,    83,    84,    56,    57,    68,    76,     7,
     105,     7,   106,   107,    68,   105,     5,    29,    30,    31,
      32,    33,    34,    35,    36,    18,    25,     3,     4,     5,
       7,    37,    38,    18,    25,    44,    45,    46,    47,    98,
      96,    96,   104,   104,   104,   104,   104,   104,   104,   103,
     103,    69,    69,    18,    69,    40,   113,   113,   113,   113,
     113,    24,    24,   113,   113,   112,    39,    39,    39,    39,
      39,    39,   117,    81,    18,    18,   105,   106,   107,   105,
      41,     3,     3,    82,    96,    96,    68,    25,    25,    41,
      25,    43,    25,    43,    69,   113,   113,    77,   105
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

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
#ifndef	YYINITDEPTH
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
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
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
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
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
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
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
	    /* Fall through.  */
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

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

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
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
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
      if (yyn == 0 || yyn == YYTABLE_NINF)
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

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

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
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

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

/* Line 1455 of yacc.c  */
#line 105 "gram.y"
    {
		YYACCEPT;
	}
    break;

  case 3:

/* Line 1455 of yacc.c  */
#line 108 "gram.y"
    {
		YYABORT;
	}
    break;

  case 4:

/* Line 1455 of yacc.c  */
#line 113 "gram.y"
    {
		debugvf("Executing saved Select statment: %s\n", (char *)(yyvsp[(2) - (2)].string));
		stmt.type = SQL_TYPE_EXEC_SAVED_SELECT;
		stmt.name = (char *)(yyvsp[(2) - (2)].string);
	}
    break;

  case 5:

/* Line 1455 of yacc.c  */
#line 118 "gram.y"
    {
		debugvf("Deleting query %s\n", (char*)(yyvsp[(3) - (3)].string));
		stmt.type = SQL_TYPE_DELETE_QUERY;
		stmt.name = (char*)(yyvsp[(3) - (3)].string);
	}
    break;

  case 6:

/* Line 1455 of yacc.c  */
#line 123 "gram.y"
    {
		
		debugvf("Saving a Select statment as: %s.\n", (char *)(yyvsp[(6) - (6)].string));		
		stmt.type = SQL_TYPE_SAVE_SELECT;
		
		/* Store the save-as name */
		stmt.name = (char *)(yyvsp[(6) - (6)].string);
		
		/* Columns */
		stmt.sql.select.ncols =  list_len(clist);
		stmt.sql.select.cols = (char **) list_to_array(clist);
		list_free(clist);
		clist=NULL;
		
		/* Column attribs (count, min, max, avg, sum) */
		stmt.sql.select.colattrib = (int **) list_to_array(cattriblist);
		list_free(cattriblist);
		cattriblist = NULL;
		
		/* From Tables */
		stmt.sql.select.ntables = list_len(tlist);
		stmt.sql.select.tables = (char **) list_to_array(tlist);
		list_free(tlist);
		tlist=NULL;
		
		/* Table windows */
		if (wlist) {
			stmt.sql.select.windows = (sqlwindow **) list_to_array(wlist);
			list_free(wlist);
			wlist=NULL;
		}
		
		/* Where filters */
		if (flist) {
			stmt.sql.select.nfilters = list_len(flist);
			stmt.sql.select.filters = (sqlfilter **) list_to_array(flist);
			stmt.sql.select.filtertype = filtertype;
			list_free(flist);
			flist=NULL;
		}
		
		/* Order by */
		if (orderby) {
			stmt.sql.select.orderby = orderby;
		} else {
			stmt.sql.select.orderby = NULL;
		}
		
		/* Count(*) ? */
		if (countstar) {
			debugvf("Is count(*)\n");
			stmt.sql.select.isCountStar = 1;
		} else {
			debugvf("Not count(*)\n");
			stmt.sql.select.isCountStar = 0;
		}
		
	}
    break;

  case 7:

/* Line 1455 of yacc.c  */
#line 181 "gram.y"
    {
	
		debugvf("Select statment.\n");
		stmt.type = SQL_TYPE_SELECT;
		
		/* Columns */
		stmt.sql.select.ncols =  list_len(clist);
		stmt.sql.select.cols = (char **) list_to_array(clist);
		list_free(clist);
		clist=NULL;
		
		/* Column attribs (count, min, max, avg, sum) */
		stmt.sql.select.colattrib = (int **) list_to_array(cattriblist);
		list_free(cattriblist);
		cattriblist = NULL;
		
		/* From Tables */
		stmt.sql.select.ntables = list_len(tlist);
		stmt.sql.select.tables = (char **) list_to_array(tlist);
		list_free(tlist);
		tlist=NULL;
		
		/* Table windows */
		if (wlist) {
			stmt.sql.select.windows = (sqlwindow **) list_to_array(wlist);
			list_free(wlist);
			wlist=NULL;
		}
		
		/* Where filters */
		if (flist) {
			stmt.sql.select.nfilters = list_len(flist);
			stmt.sql.select.filters = (sqlfilter **) list_to_array(flist);
			stmt.sql.select.filtertype = filtertype;
			list_free(flist);
			flist=NULL;
		}
	
		/* Order by */
		if (orderby) {
			stmt.sql.select.orderby = orderby;
		} else {
			stmt.sql.select.orderby = NULL;
		}
		
		/* Count(*) ? */
		if (countstar) {
			debugvf("Is count(*)\n");
			stmt.sql.select.isCountStar = 1;
		} else {
			debugvf("Not count(*)\n");
			stmt.sql.select.isCountStar = 0;
		}

		/* Group by */
		if (grouplist) {
			stmt.sql.select.groupby_ncols =  list_len(grouplist);
			stmt.sql.select.groupby_cols = (char **) list_to_array(grouplist);
			list_free(grouplist);
			grouplist=NULL;
		} else {
			stmt.sql.select.groupby_ncols = 0;
			stmt.sql.select.groupby_cols = NULL;
		}
	}
    break;

  case 8:

/* Line 1455 of yacc.c  */
#line 246 "gram.y"
    {
		
		debugvf("Create statement.\n");
		stmt.type = SQL_TYPE_CREATE;
		
		stmt.sql.create.tablename = tablename;
		stmt.sql.create.ncols = list_len(colnames);
		stmt.sql.create.colname = (char **) list_to_array(colnames);
		stmt.sql.create.coltype = (int **) list_to_array(coltypes);
		list_free(colnames);
		colnames=NULL;
		list_free(coltypes);
		coltypes=NULL;
		stmt.sql.create.tabletype = tabletype;
		stmt.sql.create.primary_column = primary_column;
	}
    break;

  case 9:

/* Line 1455 of yacc.c  */
#line 262 "gram.y"
    {
		
		debugvf("Insert statement.\n");
		stmt.type = SQL_TYPE_INSERT;
		
		stmt.sql.insert.tablename = tablename;
		stmt.sql.insert.ncols = list_len(colvals);
		stmt.sql.insert.colval = (char **) list_to_array(colvals);
		stmt.sql.insert.coltype = (int **) list_to_array(coltypes);
		stmt.sql.insert.transform = transform;
		list_free(colvals);
		colvals=NULL;
		list_free(coltypes);
		coltypes=NULL;
	}
    break;

  case 10:

/* Line 1455 of yacc.c  */
#line 277 "gram.y"
    {
		
		debugvf("Update statement.\n");
		stmt.type = SQL_TYPE_UPDATE;
		stmt.sql.update.tablename = tablename;
		/* Set pairs */
		if (plist) {
			stmt.sql.update.npairs = list_len(plist);
			stmt.sql.update.pairs = (sqlpair **) list_to_array(plist);
			list_free(plist);
			plist=NULL;
		}
		/* Where filters */
		if (flist) {
			stmt.sql.update.nfilters = list_len(flist);
			stmt.sql.update.filters = (sqlfilter **) list_to_array(flist);
			stmt.sql.update.filtertype = filtertype;
			list_free(flist);
			flist=NULL;
		}
	}
    break;

  case 11:

/* Line 1455 of yacc.c  */
#line 298 "gram.y"
    {
		
		debugvf("Show tables.\n");
		stmt.type = SQL_SHOW_TABLES;
		
	}
    break;

  case 12:

/* Line 1455 of yacc.c  */
#line 304 "gram.y"
    {
		
		debugvf("Publish saved query: %s\n", (yyvsp[(2) - (2)].string));
		
		stmt.type = SQL_TYPE_PUBLISH;
		stmt.name = (yyvsp[(2) - (2)].string);
		
	}
    break;

  case 13:

/* Line 1455 of yacc.c  */
#line 312 "gram.y"
    {
		
		debugvf("Subscribe statement: query: %s; ip:port:service: %s:%s:%s\n", 
			(char*)(yyvsp[(2) - (5)].string),(char*)(yyvsp[(3) - (5)].string),(char*)(yyvsp[(4) - (5)].string),(char*)(yyvsp[(5) - (5)].string));
		stmt.type = SQL_TYPE_SUBSCRIBE;
		stmt.sql.subscribe.queryname = (yyvsp[(2) - (5)].string);
		stmt.sql.subscribe.ipaddr = (yyvsp[(3) - (5)].string);
		stmt.sql.subscribe.port = (yyvsp[(4) - (5)].string);
		stmt.sql.subscribe.service = (yyvsp[(5) - (5)].string);
	}
    break;

  case 14:

/* Line 1455 of yacc.c  */
#line 322 "gram.y"
    {
		
		debugvf("Unsubscribe statement: query: %s; ip:port:service: %s:%s:%s\n", 
			(char*)(yyvsp[(2) - (5)].string),(char*)(yyvsp[(3) - (5)].string),(char*)(yyvsp[(4) - (5)].string),(char*)(yyvsp[(5) - (5)].string));
		stmt.type = SQL_TYPE_UNSUBSCRIBE;
		stmt.sql.subscribe.queryname = (yyvsp[(2) - (5)].string);
		stmt.sql.subscribe.ipaddr = (yyvsp[(3) - (5)].string);
		stmt.sql.subscribe.port = (yyvsp[(4) - (5)].string);
		stmt.sql.subscribe.service = (yyvsp[(5) - (5)].string);
	}
    break;

  case 15:

/* Line 1455 of yacc.c  */
#line 332 "gram.y"
    {
		
		debugvf("Register statement: automaton: %s\nip:port:service: %s:%s:%s\n", 
			(char*)(yyvsp[(2) - (5)].string),(char*)(yyvsp[(3) - (5)].string),(char*)(yyvsp[(4) - (5)].string),(char*)(yyvsp[(5) - (5)].string));
		stmt.type = SQL_TYPE_REGISTER;
		stmt.sql.regist.automaton = (yyvsp[(2) - (5)].string);
		stmt.sql.regist.ipaddr = (yyvsp[(3) - (5)].string);
		stmt.sql.regist.port = (yyvsp[(4) - (5)].string);
		stmt.sql.regist.service = (yyvsp[(5) - (5)].string);
	}
    break;

  case 16:

/* Line 1455 of yacc.c  */
#line 342 "gram.y"
    {
		
		debugvf("Unregister statement: automaton id: %s\n", (char *)(yyvsp[(2) - (2)].string));
		stmt.type = SQL_TYPE_UNREGISTER;
		stmt.sql.unregist.id = (yyvsp[(2) - (2)].string);
	}
    break;

  case 17:

/* Line 1455 of yacc.c  */
#line 351 "gram.y"
    { orderby = NULL;}
    break;

  case 18:

/* Line 1455 of yacc.c  */
#line 352 "gram.y"
    {orderby = NULL;}
    break;

  case 21:

/* Line 1455 of yacc.c  */
#line 355 "gram.y"
    { orderby = NULL; countstar = 0; }
    break;

  case 22:

/* Line 1455 of yacc.c  */
#line 356 "gram.y"
    { orderby = NULL; countstar = 0;}
    break;

  case 23:

/* Line 1455 of yacc.c  */
#line 357 "gram.y"
    {countstar = 0;}
    break;

  case 24:

/* Line 1455 of yacc.c  */
#line 358 "gram.y"
    {countstar = 0;}
    break;

  case 25:

/* Line 1455 of yacc.c  */
#line 359 "gram.y"
    {orderby = NULL; countstar = 0;}
    break;

  case 26:

/* Line 1455 of yacc.c  */
#line 361 "gram.y"
    {orderby = NULL; countstar = 0;}
    break;

  case 27:

/* Line 1455 of yacc.c  */
#line 363 "gram.y"
    {countstar = 0;}
    break;

  case 30:

/* Line 1455 of yacc.c  */
#line 372 "gram.y"
    {
		debugvf("Col: %s\n", (char *)(yyvsp[(1) - (1)].string));
		if (!clist)
			clist = list_new();
		list_append(clist, (void *)(yyvsp[(1) - (1)].string));
		
		if (!cattriblist)
			cattriblist = list_new();
		list_append(cattriblist, (void *)SQL_COLATTRIB_NONE);
	}
    break;

  case 31:

/* Line 1455 of yacc.c  */
#line 392 "gram.y"
    {
		debugvf("Col (MIN): %s\n", (char *)(yyvsp[(3) - (4)].string));
		if (!clist)
			clist = list_new();
		list_append(clist, (void *)(yyvsp[(3) - (4)].string));
		
		if (!cattriblist)
			cattriblist = list_new();
		list_append(cattriblist, (void *)SQL_COLATTRIB_MIN);
		stmt.sql.select.containsMinMaxAvgSum = 1;
	}
    break;

  case 32:

/* Line 1455 of yacc.c  */
#line 403 "gram.y"
    {
		debugvf("Col (MAX): %s\n", (char *)(yyvsp[(3) - (4)].string));
		if (!clist)
			clist = list_new();
		list_append(clist, (void *)(yyvsp[(3) - (4)].string));
		
		if (!cattriblist)
			cattriblist = list_new();
		list_append(cattriblist, (void *)SQL_COLATTRIB_MAX);
		stmt.sql.select.containsMinMaxAvgSum = 1;
	}
    break;

  case 33:

/* Line 1455 of yacc.c  */
#line 414 "gram.y"
    {
		debugvf("Col (AVG): %s\n", (char *)(yyvsp[(3) - (4)].string));
		if (!clist)
			clist = list_new();
		list_append(clist, (void *)(yyvsp[(3) - (4)].string));
		
		if (!cattriblist)
			cattriblist = list_new();
		list_append(cattriblist, (void *)SQL_COLATTRIB_AVG);
		stmt.sql.select.containsMinMaxAvgSum = 1;
	}
    break;

  case 34:

/* Line 1455 of yacc.c  */
#line 425 "gram.y"
    {
		debugvf("Col (SUM): %s\n", (char *)(yyvsp[(3) - (4)].string));
		if (!clist)
			clist = list_new();
		list_append(clist, (void *)(yyvsp[(3) - (4)].string));
		
		if (!cattriblist)
			cattriblist = list_new();
		list_append(cattriblist, (void *)SQL_COLATTRIB_SUM);
		stmt.sql.select.containsMinMaxAvgSum = 1;
	}
    break;

  case 35:

/* Line 1455 of yacc.c  */
#line 439 "gram.y"
    {
		debugvf("Select *\n");
		if (!clist)
			clist = list_new();
		list_append(clist, str_dupl("*"));
		if (!cattriblist)
			cattriblist = list_new();
		list_append(cattriblist, (void *)SQL_COLATTRIB_NONE);
		countstar = 0;
	}
    break;

  case 36:

/* Line 1455 of yacc.c  */
#line 449 "gram.y"
    {
		debugvf("Select count(*)\n");
		if (!clist)
			clist = list_new();
		list_append(clist, str_dupl("*"));
		if (!cattriblist)
			cattriblist = list_new();
		list_append(cattriblist, (void *)SQL_COLATTRIB_COUNT);
		countstar = 1;
	}
    break;

  case 39:

/* Line 1455 of yacc.c  */
#line 467 "gram.y"
    {
		debugvf("Table: %s\n", (char *)(yyvsp[(1) - (1)].string));
		if (!tlist)
			tlist = list_new();
		list_append(tlist, (void *)(yyvsp[(1) - (1)].string));
		
		/* Add empty stub window */
		if (!wlist)
			wlist = list_new();
		tmpwin = sqlstmt_new_stubwindow();
		list_append(wlist, (void *)tmpwin);
	}
    break;

  case 40:

/* Line 1455 of yacc.c  */
#line 479 "gram.y"
    {
		debugvf("Table with window: %s\n", (char*)(yyvsp[(1) - (4)].string));
		if (!tlist)
			tlist = list_new();
		list_append(tlist, (void *)(yyvsp[(1) - (4)].string));
		
		/* Add window */
		if (!wlist)
			wlist = list_new();
		list_append(wlist, (void *)tmpwin);
	}
    break;

  case 43:

/* Line 1455 of yacc.c  */
#line 498 "gram.y"
    {
		debugvf("TimeWindow NOW\n");
		tmpwin = sqlstmt_new_timewindow_now();
	}
    break;

  case 44:

/* Line 1455 of yacc.c  */
#line 502 "gram.y"
    {
		debugvf("TimeWindow Range %d, unit:%d\n", atoi((yyvsp[(2) - (3)].string)), tmpunit);
		tmpwin = sqlstmt_new_timewindow(atoi((yyvsp[(2) - (3)].string)), tmpunit);
		/* NB: memory leak. need to free $2 */
		mem_free((yyvsp[(2) - (3)].string));
	}
    break;

  case 45:

/* Line 1455 of yacc.c  */
#line 508 "gram.y"
    {
		debugvf("TimeWindow Since %s\n", (yyvsp[(2) - (2)].string));
		tmpwin = sqlstmt_new_timewindow_since((yyvsp[(2) - (2)].string));
		mem_free((yyvsp[(2) - (2)].string));
	}
    break;

  case 46:

/* Line 1455 of yacc.c  */
#line 513 "gram.y"
    {
		debugvf("Timewindow Interval\n");
		tmpwin = sqlstmt_new_timewindow_interval(&tmpinterval);
	}
    break;

  case 47:

/* Line 1455 of yacc.c  */
#line 520 "gram.y"
    {
		debugvf("tstamp expression: %s\n", (yyvsp[(1) - (1)].string));
		(yyval.string) = (yyvsp[(1) - (1)].string);
	}
    break;

  case 48:

/* Line 1455 of yacc.c  */
#line 524 "gram.y"
    {
		tstamp_t tmp;
		debugvf("datestring expression: %s\n", (yyvsp[(1) - (1)].string));
		tmp = datestring_to_timestamp((yyvsp[(1) - (1)].string));
		(yyval.string) = timestamp_to_string(tmp);
		mem_free((yyvsp[(1) - (1)].string));
	}
    break;

  case 49:

/* Line 1455 of yacc.c  */
#line 534 "gram.y"
    {
		tmpinterval.leftOp = GREATER;
		tmpinterval.rightOp = LESS;
		tmpinterval.leftTs = string_to_timestamp((yyvsp[(2) - (5)].string));
		tmpinterval.rightTs = string_to_timestamp((yyvsp[(4) - (5)].string));
		mem_free((yyvsp[(2) - (5)].string));
		mem_free((yyvsp[(4) - (5)].string));
	}
    break;

  case 50:

/* Line 1455 of yacc.c  */
#line 542 "gram.y"
    {
		tmpinterval.leftOp = GREATER;
		tmpinterval.rightOp = LESSEQ;
		tmpinterval.leftTs = string_to_timestamp((yyvsp[(2) - (5)].string));
		tmpinterval.rightTs = string_to_timestamp((yyvsp[(4) - (5)].string));
		mem_free((yyvsp[(2) - (5)].string));
		mem_free((yyvsp[(4) - (5)].string));
	}
    break;

  case 51:

/* Line 1455 of yacc.c  */
#line 550 "gram.y"
    {
		tmpinterval.leftOp = GREATEREQ;
		tmpinterval.rightOp = LESS;
		tmpinterval.leftTs = string_to_timestamp((yyvsp[(2) - (5)].string));
		tmpinterval.rightTs = string_to_timestamp((yyvsp[(4) - (5)].string));
		mem_free((yyvsp[(2) - (5)].string));
		mem_free((yyvsp[(4) - (5)].string));
	}
    break;

  case 52:

/* Line 1455 of yacc.c  */
#line 558 "gram.y"
    {
		tmpinterval.leftOp = GREATEREQ;
		tmpinterval.rightOp = LESSEQ;
		tmpinterval.leftTs = string_to_timestamp((yyvsp[(2) - (5)].string));
		tmpinterval.rightTs = string_to_timestamp((yyvsp[(4) - (5)].string));
		mem_free((yyvsp[(2) - (5)].string));
		mem_free((yyvsp[(4) - (5)].string));
	}
    break;

  case 53:

/* Line 1455 of yacc.c  */
#line 569 "gram.y"
    {
		debugvf("TimeWindow unit MILLIS\n");
		tmpunit = SQL_WINTYPE_TIME_MILLIS;
	}
    break;

  case 54:

/* Line 1455 of yacc.c  */
#line 573 "gram.y"
    {
		debugvf("TimeWindow unit SECONDS\n");
		tmpunit = SQL_WINTYPE_TIME_SECONDS;
	}
    break;

  case 55:

/* Line 1455 of yacc.c  */
#line 577 "gram.y"
    {
		debugvf("TimeWindow unit MINUTES\n");
		tmpunit = SQL_WINTYPE_TIME_MINUTES;
	}
    break;

  case 56:

/* Line 1455 of yacc.c  */
#line 581 "gram.y"
    {
		debugvf("TimeWindow unit HOURS\n");
		tmpunit = SQL_WINTYPE_TIME_HOURS;
	}
    break;

  case 57:

/* Line 1455 of yacc.c  */
#line 588 "gram.y"
    {
		debugvf("TupleWindow ROWS %d\n", atoi((yyvsp[(2) - (2)].string)));
		tmpwin = sqlstmt_new_tuplewindow(atoi((yyvsp[(2) - (2)].string)));
		/* NB: memory leak. need to free $2 */
		mem_free((yyvsp[(2) - (2)].string));
	}
    break;

  case 58:

/* Line 1455 of yacc.c  */
#line 594 "gram.y"
    {
		debugvf("TupleWindow LAST\n");
		tmpwin = sqlstmt_new_tuplewindow(1);
	}
    break;

  case 60:

/* Line 1455 of yacc.c  */
#line 602 "gram.y"
    {
		debugvf("Filter type: AND\n");
		filtertype = SQL_FILTER_TYPE_AND;
	}
    break;

  case 61:

/* Line 1455 of yacc.c  */
#line 606 "gram.y"
    {
		debugvf("Filter type: OR\n");
		filtertype = SQL_FILTER_TYPE_OR;
	}
    break;

  case 63:

/* Line 1455 of yacc.c  */
#line 614 "gram.y"
    {
		debugvf("Pair separator: COMMA\n");
	}
    break;

  case 64:

/* Line 1455 of yacc.c  */
#line 620 "gram.y"
    {
		debugvf("Pair (WORD=constant): %s = %s\n", (char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!plist)
			plist = list_new();
		tmppair = sqlstmt_new_pair(EQUALS, (char*)(yyvsp[(1) - (3)].string), tmpvaltype, tmpvalstr);
		list_append(plist, (void *)tmppair);
		mem_free(tmpvalstr);
	}
    break;

  case 65:

/* Line 1455 of yacc.c  */
#line 628 "gram.y"
    {
		debugvf("Pair (WORD+=constant): %s += %s\n", (char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!plist)
			plist = list_new();
		tmppair = sqlstmt_new_pair(ADD, (char*)(yyvsp[(1) - (3)].string), tmpvaltype, tmpvalstr);
		list_append(plist, (void *)tmppair);
		mem_free(tmpvalstr);
	}
    break;

  case 66:

/* Line 1455 of yacc.c  */
#line 636 "gram.y"
    {
		debugvf("Pair (WORD-=constant): %s -= %s\n", (char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!plist)
			plist = list_new();
		tmppair = sqlstmt_new_pair(SUB, (char*)(yyvsp[(1) - (3)].string), tmpvaltype, tmpvalstr);
		list_append(plist, (void *)tmppair);
		mem_free(tmpvalstr);
	}
    break;

  case 67:

/* Line 1455 of yacc.c  */
#line 647 "gram.y"
    {
		debugvf("Filter (WORD==constant): %s == %s\n",
			(char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!flist)
			flist = list_new();
		tmpfilter = sqlstmt_new_filter(EQUALS, (char*)(yyvsp[(1) - (3)].string),
					       tmpvaltype, tmpvalstr);
		list_append(flist, (void *)tmpfilter);
		mem_free(tmpvalstr);
	}
    break;

  case 68:

/* Line 1455 of yacc.c  */
#line 657 "gram.y"
    {
		debugvf("Filter (WORD<constant): %s == %s\n",
			(char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!flist)
			flist = list_new();
		tmpfilter = sqlstmt_new_filter(LESS, (char*)(yyvsp[(1) - (3)].string),
					       tmpvaltype, tmpvalstr);
		list_append(flist, (void *)tmpfilter);
		mem_free(tmpvalstr);
	}
    break;

  case 69:

/* Line 1455 of yacc.c  */
#line 667 "gram.y"
    {
		debugvf("Filter (WORD>constant): %s == %s\n",
                        (char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!flist)
			flist = list_new();
		tmpfilter = sqlstmt_new_filter(GREATER, (char*)(yyvsp[(1) - (3)].string),
                                               tmpvaltype, tmpvalstr);
		list_append(flist, (void *)tmpfilter);
		mem_free(tmpvalstr);
	}
    break;

  case 70:

/* Line 1455 of yacc.c  */
#line 677 "gram.y"
    {
		debugvf("Filter (WORD<=constant): %s == %s\n",
                        (char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!flist)
			flist = list_new();
		tmpfilter = sqlstmt_new_filter(LESSEQ, (char*)(yyvsp[(1) - (3)].string),
                                               tmpvaltype, tmpvalstr);
		list_append(flist, (void *)tmpfilter);
		mem_free(tmpvalstr);
	}
    break;

  case 71:

/* Line 1455 of yacc.c  */
#line 687 "gram.y"
    {
		debugvf("Filter (WORD>=constant): %s == %s\n",
                        (char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!flist)
			flist = list_new();
		tmpfilter = sqlstmt_new_filter(GREATEREQ, (char*)(yyvsp[(1) - (3)].string),
                                               tmpvaltype, tmpvalstr);
		list_append(flist, (void *)tmpfilter);
		mem_free(tmpvalstr);
	}
    break;

  case 72:

/* Line 1455 of yacc.c  */
#line 697 "gram.y"
    {
		debugvf("Filter (WORD contains constant): %s contains %s\n",
			(char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!flist)
			flist = list_new();
		tmpfilter = sqlstmt_new_filter(CONTAINS, (char*)(yyvsp[(1) - (3)].string), tmpvaltype, tmpvalstr);
		list_append(flist, (void *)tmpfilter);
		mem_free(tmpvalstr);
	}
    break;

  case 73:

/* Line 1455 of yacc.c  */
#line 706 "gram.y"
    {
		debugvf("Filter (WORD notcontains constant): %s notcontains %s\n",
			(char *)(yyvsp[(1) - (3)].string), tmpvalstr);
		if (!flist)
			flist = list_new();
		tmpfilter = sqlstmt_new_filter(NOTCONTAINS, (char*)(yyvsp[(1) - (3)].string), tmpvaltype, tmpvalstr);
		list_append(flist, (void *)tmpfilter);
		mem_free(tmpvalstr);
	}
    break;

  case 74:

/* Line 1455 of yacc.c  */
#line 717 "gram.y"
    {
		tmpvaltype = INTEGER;
		tmpvalstr = (char *)(yyvsp[(1) - (1)].string);
	}
    break;

  case 75:

/* Line 1455 of yacc.c  */
#line 721 "gram.y"
    {
		tmpvaltype = REAL;
		tmpvalstr = (char *)(yyvsp[(1) - (1)].string);
	}
    break;

  case 76:

/* Line 1455 of yacc.c  */
#line 725 "gram.y"
    {
		tmpvaltype = TSTAMP;
		tmpvalstr = (char *)(yyvsp[(1) - (1)].string);
	}
    break;

  case 77:

/* Line 1455 of yacc.c  */
#line 729 "gram.y"
    {
	        char *p = (char *)malloc(strlen((yyvsp[(1) - (1)].string)));
	        sscanf((yyvsp[(1) - (1)].string),"\"%s\"",p);
       	        int i;
	        debugvf("Value varchar: %s\n", (yyvsp[(1) - (1)].string));
	        i = strlen(p) - 1;	/* will point at \" || \n*/
	        p[i] = '\0';		/* overwrite it */
	  
	        tmpvaltype = VARCHAR;
	        tmpvalstr = strdup(p);
		
	}
    break;

  case 78:

/* Line 1455 of yacc.c  */
#line 744 "gram.y"
    {
		debugvf("Order by: %s\n", (char *)(yyvsp[(1) - (1)].string));
		orderby = (yyvsp[(1) - (1)].string);
	}
    break;

  case 81:

/* Line 1455 of yacc.c  */
#line 756 "gram.y"
    {
		debugvf("Group by col: %s\n", (char *)(yyvsp[(1) - (1)].string));
		if (!grouplist)
			grouplist = list_new();
		list_append(grouplist, (void *)(yyvsp[(1) - (1)].string));
	}
    break;

  case 82:

/* Line 1455 of yacc.c  */
#line 764 "gram.y"
    { column = 0; }
    break;

  case 83:

/* Line 1455 of yacc.c  */
#line 764 "gram.y"
    {
		debugvf("Tablename: %s\n", (char *)(yyvsp[(3) - (7)].string));
		tablename = (yyvsp[(3) - (7)].string);
	}
    break;

  case 84:

/* Line 1455 of yacc.c  */
#line 771 "gram.y"
    {
		debugvf("tabDec: table\n");
		tabletype = 0;
		primary_column = -1;
	}
    break;

  case 85:

/* Line 1455 of yacc.c  */
#line 776 "gram.y"
    {
		debugvf("tabDec: persistenttable\n");
		tabletype = 1;
		primary_column = -1;
	}
    break;

  case 88:

/* Line 1455 of yacc.c  */
#line 789 "gram.y"
    {
		debugvf("varDec boolean: %s\n", (yyvsp[(1) - (3)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_BOOLEAN);
	}
    break;

  case 89:

/* Line 1455 of yacc.c  */
#line 801 "gram.y"
    {
		debugvf("varDec integer: %s\n", (yyvsp[(1) - (3)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_INTEGER);
	}
    break;

  case 90:

/* Line 1455 of yacc.c  */
#line 813 "gram.y"
    {
		debugvf("varDec real: %s\n", (yyvsp[(1) - (3)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_REAL);
	}
    break;

  case 91:

/* Line 1455 of yacc.c  */
#line 825 "gram.y"
    {
		debugvf("varDec character: %s\n", (yyvsp[(1) - (3)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_CHARACTER);
	}
    break;

  case 92:

/* Line 1455 of yacc.c  */
#line 837 "gram.y"
    {
		debugvf("varDec varchar: %s\n", (yyvsp[(1) - (6)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (6)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_VARCHAR);
		
		mem_free((yyvsp[(4) - (6)].string));
	}
    break;

  case 93:

/* Line 1455 of yacc.c  */
#line 851 "gram.y"
    {
		debugvf("varDec blob: %s\n", (yyvsp[(1) - (6)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (6)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_BLOB);
	}
    break;

  case 94:

/* Line 1455 of yacc.c  */
#line 863 "gram.y"
    {
		debugvf("varDec tinyint: %s\n", (yyvsp[(1) - (3)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_TINYINT);
	}
    break;

  case 95:

/* Line 1455 of yacc.c  */
#line 875 "gram.y"
    {
		debugvf("varDec smallint: %s\n", (yyvsp[(1) - (3)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_SMALLINT);
	}
    break;

  case 96:

/* Line 1455 of yacc.c  */
#line 887 "gram.y"
    {
		debugvf("varDec timestamp: %s\n", (yyvsp[(1) - (3)].string));
		
		column++;
		if (!colnames)
			colnames = list_new();
		list_append(colnames, (void *)(yyvsp[(1) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_TIMESTAMP);
	}
    break;

  case 97:

/* Line 1455 of yacc.c  */
#line 902 "gram.y"
    { /* do nothing */
	}
    break;

  case 98:

/* Line 1455 of yacc.c  */
#line 904 "gram.y"
    {
		if (! tabletype) {
			errorf("primary key defined for non-persistent table.\n");
			YYABORT;
		} else if (primary_column != -1) {
			errorf("two or more primary keys declared\n");
			YYABORT;
		} else {
			primary_column = column;
		}
	}
    break;

  case 99:

/* Line 1455 of yacc.c  */
#line 918 "gram.y"
    {
		debugvf("Tablename: %s\n", (char *)(yyvsp[(3) - (7)].string));
		tablename = (yyvsp[(3) - (7)].string);
		transform = 0;
	}
    break;

  case 100:

/* Line 1455 of yacc.c  */
#line 923 "gram.y"
    {
		debugvf("Tablename: %s\n", (char *)(yyvsp[(3) - (11)].string));
		tablename = (yyvsp[(3) - (11)].string);
		transform = 1;
	}
    break;

  case 101:

/* Line 1455 of yacc.c  */
#line 931 "gram.y"
    {
		debugvf("Update table %s\n", (char *)(yyvsp[(2) - (6)].string));
		tablename = (yyvsp[(2) - (6)].string);
	}
    break;

  case 104:

/* Line 1455 of yacc.c  */
#line 943 "gram.y"
    {
		debugvf("Value bool true\n");
		
		if (!colvals)
			colvals = list_new();
		list_append(colvals, str_dupl("1"));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_BOOLEAN);
	}
    break;

  case 105:

/* Line 1455 of yacc.c  */
#line 954 "gram.y"
    {
		debugvf("Value bool false\n");
		
		if (!colvals)
			colvals = list_new();
		list_append(colvals, str_dupl("0"));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_BOOLEAN);
	}
    break;

  case 106:

/* Line 1455 of yacc.c  */
#line 965 "gram.y"
    {
		debugvf("Value int: %s\n", (yyvsp[(2) - (3)].string));
		
		if (!colvals)
			colvals = list_new();
		list_append(colvals, (void *)(yyvsp[(2) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_INTEGER);
	}
    break;

  case 107:

/* Line 1455 of yacc.c  */
#line 976 "gram.y"
    {
		debugvf("Value real: %s\n", (yyvsp[(2) - (3)].string));
		
		if (!colvals)
			colvals = list_new();
		list_append(colvals, (void *)(yyvsp[(2) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_REAL);
	}
    break;

  case 108:

/* Line 1455 of yacc.c  */
#line 987 "gram.y"
    {
		debugvf("Value tstamp: %s\n", (yyvsp[(2) - (3)].string));
		
		if (!colvals)
			colvals = list_new();
		list_append(colvals, (void *)(yyvsp[(2) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_TIMESTAMP);
	}
    break;

  case 109:

/* Line 1455 of yacc.c  */
#line 998 "gram.y"
    {
		debugvf("Value varchar: %s\n", (yyvsp[(2) - (3)].string));
		
		if (!colvals)
			colvals = list_new();
		list_append(colvals, (void *)(yyvsp[(2) - (3)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_VARCHAR);
	}
    break;

  case 110:

/* Line 1455 of yacc.c  */
#line 1009 "gram.y"
    {
		char *p = (yyvsp[(1) - (1)].string);
		int i;
		debugvf("Value varchar: %s\n", (yyvsp[(1) - (1)].string));
		i = strlen(p) - 1;	/* will point at \" || \n*/
		p[i] = '\0';		/* overwrite it */

		if (!colvals)
			colvals = list_new();
		list_append(colvals, (void *)str_dupl(p+1));
		mem_free((yyvsp[(1) - (1)].string));
		
		if (!coltypes)
			coltypes = list_new();
		list_append(coltypes, (void *)PRIMTYPE_VARCHAR);
	}
    break;

  case 111:

/* Line 1455 of yacc.c  */
#line 1025 "gram.y"
    {
		debugvf("Wrong value.\n");
	}
    break;



/* Line 1455 of yacc.c  */
#line 3164 "y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
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

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
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
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
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

  *++yyvsp = yylval;


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

#if !defined(yyoverflow) || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
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
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 1030 "gram.y"



