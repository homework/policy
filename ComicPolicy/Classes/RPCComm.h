//
//  RPCSend.h
//  ContentionApp
//
//  Created by Tom Lodge on 20/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "config.h"
#include "srpc.h"
#include "util.h"
#include "rtab.h"
#include "i8_parser.h"
#include "timestamp.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <signal.h>
#include <pthread.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

typedef struct dhcp_data {
	unsigned int action; // 0:add 1:del 2:old
	uint64_t mac_addr;
	in_addr_t ip_addr;
	char hostname[70];
	tstamp_t tstamp;
} DhcpData;

typedef struct lease_results {
    unsigned long nleases;
    DhcpData **data;
} DhcpResults;

typedef struct policy_data{
    char action[5];
    unsigned long identifier;
    char metadata[256];
    tstamp_t tstamp;
}PolicyData;


@interface RPCComm : NSObject {
	
}

+ (RPCComm *)sharedRPCComm;
unsigned int action2index(char *action);
char *index2action(unsigned int index);
void dhcp_free(DhcpResults *p);

DhcpResults *dhcp_convert(Rtab *results);
uint64_t string_to_mac(char *s);

void policy_free(PolicyData *p);
PolicyData *policy_convert(Rtab *results);

-(id) init:(NSString*) gwaddr;

-(BOOL) connect;
-(BOOL) send: (void *) query qlen:(unsigned) qlen resp: (void*) resp rsize:(unsigned) rs len:(unsigned *) len;
-(BOOL) subscribe:(NSString*)host query:(char*) query;
-(BOOL) sendquery:(NSString *)q;
-(void) notifydisconnected:(NSObject*)o;
-(void) notifyconnected:(NSObject*)o;



@end
