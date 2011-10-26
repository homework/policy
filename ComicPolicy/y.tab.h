
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
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

/* Line 1676 of yacc.c  */
#line 66 "gram.y"

    long long number;
    double numfloat;
    char character;
    char *string;
    unsigned long long tstamp;



/* Line 1676 of yacc.c  */
#line 230 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


