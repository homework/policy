/*
 * tslist.h - public data structures and entry points for thread-safe
 *            linked lists used in RPC system
 *
 * each element in the list consists of two parts: a sockaddr_in (either the
 * sender of the data or the recipient of the response) and the data buffer to
 * send
 */

#ifndef _LIST_H_INCLUDED_
#define _LIST_H_INCLUDED_

typedef void *TSList;

/* constructor
 * returns NULL if error */
TSList tsl_create();

/* append element to the list
 * returns 0 if failure to append (malloc failure), otherwise 1 */
int tsl_append(TSList tsl, void *a, void *b, int size);

/* prepend element to the list
 * returns 0 if failure to prepend (malloc failure), otherwise 1 */
int tsl_prepend(TSList tsl, void *a, void *b, int size);

/* remove first element of the list; thread blocks until successful */
void tsl_remove(TSList tsl, void **a, void **b, int *size);

/* remove first element of the list if there, do not block, return 1/0 */
int tsl_remove_nb(TSList tsl, void **a, void **b, int *size);

#endif /* _LIST_H_INCLUDED_*/
