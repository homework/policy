/* mem.c
 * 
 * Malloc wrapper
 * 
 * Created by Oliver Sharma on 2007-03-26.
 * Modified by Joe Sventek on 2009-12-16
 * Modified by Joe Sventek on 2009-12-19 to add str_dupl
 * Copyright (c) 2007. All rights reserved.
 *
 * Based on chapter 5 in book "C Interfaces and Implementations by
 * David R. Hanson"
 */
#include "mem.h"

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
//#define TRACK_ALLOC

int log_allocation = 0;		/* if true, log size on stdout */

void *mem_alloc_location(size_t nbytes, const char *file, int line) {
   void *p;
#ifdef TRACK_ALLOC
   size_t *i;
   size_t n = nbytes + sizeof(size_t);
#else
   size_t n = nbytes;
#endif
      
   p = malloc(n);
   if (p) {
#ifdef TRACK_ALLOC
      i = (size_t *)p;
      *i = nbytes;
      p = (void *)((unsigned char *)p + sizeof(size_t));
#endif
      if (log_allocation) {
#ifdef TRACK_ALLOC
         printf("+%p:%6zd:%s:%d\n", p, nbytes, file, line);
#else
         printf("%p allocated @ %s/line %d, %zd bytes\n", p, file, line, nbytes);
#endif
      }
   } else {
        printf("Memory allocation failure @ %s/line %d, %zd bytes\n", file, line, nbytes);
	abort();
   }
   return p;
}

void mem_free_location(void *ptr, const char *file, int line) {
   void *p;
#ifdef TRACK_ALLOC
   size_t *i;
#endif
   if (! ptr)
      return;
#ifdef TRACK_ALLOC
   p = (void *)((unsigned char *)ptr - sizeof(size_t));
   i = (size_t *)p;
#else
   p = ptr;
#endif
   if (log_allocation) {
#ifdef TRACK_ALLOC
      printf("-%p:%6zd:%s:%d\n", ptr, *i, file, line);
#else
      printf("%p dealloced @ %s/line %d\n", ptr, file, line);
#endif
   }
   free(p);
}

char *str_dupl_location(const char *s, const char *file, int line) {
   int n = strlen(s) + 1;
   char *p = (char *)mem_alloc_location(n, file, line);
   if (p)
      strcpy(p, s);
   return p;
}

void mem_heap_end_address(char *leadString) {
   printf("%s %p\n", leadString, sbrk(0));
}
