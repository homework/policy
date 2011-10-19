//
//  RPCSend.h
//  ContentionApp
//
//  Created by Tom Lodge on 20/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
#import "FiredEvent.h"
#import "PolicyStateObject.h"
#import "PolicyManager.h"
#import "Catalogue.h"
#import "URLObject.h"
#import "UsageData.h"

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
    char action[6];
    unsigned long identifier;
    char metadata[257];
    tstamp_t tstamp;
}PolicyData;


typedef struct policy_request{
    unsigned int requestid;
    char request[9];
    unsigned int pid;
    char pondertalk[1025];
    tstamp_t tstamp;
}PolicyRequest;

typedef struct policy_state_results {
    unsigned long npolicies;
    PolicyState **data;
} PolicyStateResults;


typedef struct url_results{
    unsigned long nurls;
    Url **data;
} UrlResults;


typedef struct fired_results{
    unsigned long nfired;
    PolicyFired **data;
} FiredResults;


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

void policy_response_free(PolicyResponse *p);
PolicyResponse *policy_response_convert(Rtab *results);

void policy_request_free(PolicyRequest *p);
PolicyRequest *policy_request_convert(Rtab *results);

PolicyStateResults *policy_state_convert(Rtab *results);
void policy_state_free(PolicyState *p);
void policy_state_results_free(PolicyStateResults *p);
tstamp_t processpolicystateresults(char *buf, unsigned int len);


void policy_fired_free(PolicyFired *p);
PolicyFired *policy_fired_convert(Rtab *results);
tstamp_t processfiredresults(char *buf, unsigned int len);

void url_results_free(UrlResults *ur);
UrlResults *url_convert(Rtab* results);
tstamp_t processurlesults(char *buf, unsigned int len);

long long usage_convert(Rtab* results);
tstamp_t processusageresults(char *buf, unsigned int len);

UsageData* flow_convert(Rtab* results);
tstamp_t processflowresults(char *buf, unsigned int len);

long long allowance_convert(Rtab* results);
tstamp_t processallowanceresults(char *buf, unsigned int len);

-(void) setSetUpHWDBConnection:(NSString *) gwaddr callback:(NSString *) cb;
-(BOOL) connect;
//-(BOOL) send: (void *) query qlen:(unsigned) qlen resp: (void*) resp rsize:(unsigned) rs len:(unsigned *) len;
//-(BOOL) subscribe:(NSString*)host query:(char*) query;

-(void) subscribe_to_policy_response;
-(void) subscribe_to_policy_fired;
-(void) unsubscribe_from_policy_fired;
-(void) unsubscribe_from_policy_response;
-(void) closeHWDBConnection;

-(void) getStoredPolicies;
-(void) getHouseholdAllowance;
-(void) getURLsBrowsedBy:(NSString*) ipaddr;
-(void) getCumulativeBandwidthFor:(NSString *) ipaddr;
-(void) getIsUsedFor:(NSString *) ipaddr;

-(void) query:(NSString *)q;
-(void) notifydisconnected:(NSObject*)o;
-(void) notifyconnected:(NSObject*)o;



@end
