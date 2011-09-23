//
//  RPCSend.m
//  ContentionApp
//
//  Created by Tom Lodge on 20/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RPCComm.h"


@interface RPCComm (PrivateMethods)
+(NSString *)getGatewayAddress;
-(BOOL) subscribe: (NSString*) listeninghost service:(char*) service query:(char*) query handler: (void * (void *args)) handler;
@end

@implementation RPCComm

static RpcConnection rpc;
static char *host;
static unsigned short port;
static BOOL connected;
static char hwdbaddr[16];
static char response[SOCK_RECV_BUF_LEN];
static char sendquery[SOCK_RECV_BUF_LEN];
static unsigned querylen;
static unsigned length;
static RpcService firedservice, responseservice;

char* responseservicename; 
char* firedservicename; 

+ (RPCComm *)sharedRPCComm
{
    static RPCComm * sRPCComm;
    
    // This can be called on any thread, so we synchronise.  We only do this in 
    // the sNetworkManager case because, once sNetworkManager goes non-nil, it can 
    // never go nil again.
    
    if (sRPCComm == nil) {
        @synchronized (self) {
            sRPCComm = [[RPCComm alloc] init];
            assert(sRPCComm != nil);
        }
    }
    return sRPCComm;
}

-(id) init:(NSString *) gwaddr{
    self = [super init];
    
    if (self != nil) {
        port = 987;
        
        NSLog(@"WIFI IP ADDR IS %@",gwaddr);
        
        sprintf(hwdbaddr, [gwaddr UTF8String]);
        
        host = hwdbaddr;
        //port = HWDB_SERVER_PORT;
        
        connected = FALSE;
        
        NSLog(@"initing rpc");
        
        if (!rpc_init(0)) {
            fprintf(stderr, "Failure to initialize rpc system\n");
            exit(1);
        }
        
        NSLog(@"initialised rpc");
    }
    return self;
}


-(BOOL) connect:(NSString*) callbackaddr{
	NSLog(@"connecting to router %s, %d", host, port);
	rpc = rpc_connect(host, port, "HWDB", 1l);
	if (rpc){
        [self subscribe_to_policy_fired:callbackaddr];
        [self subscribe_to_policy_response:callbackaddr];
		connected = TRUE;
		[self performSelectorOnMainThread:@selector(notifyconnected:) withObject:nil waitUntilDone:NO];
		NSLog(@"successfully connected");
		return TRUE;
	}
	[self performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];

    return FALSE;
}

-(BOOL) sendquery:(NSString *)q{
	sprintf(sendquery, [q UTF8String]);
	querylen = strlen(sendquery) + 1;
	return [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:&length];
}

static void *policy_fired_handler(void *args) {
    printf("in policy fired handler\n");
    char event[SOCK_RECV_BUF_LEN], resp[100];
	char stsmsg[RTAB_MSG_MAX_LENGTH];
	RpcConnection sender;
	unsigned len, rlen;
	
    Rtab *results;
    
	PolicyFired *pf;
	
    while ((len = rpc_query(firedservice, &sender, event, SOCK_RECV_BUF_LEN)) > 0) {
        
		sprintf(resp, "OK");
		rlen = strlen(resp) + 1;
		rpc_response(firedservice, sender, resp, rlen);
		event[len] = '\0';
		results = rtab_unpack(event, len);
		if (results && ! rtab_status(event, stsmsg)) {
			printf("got fired results\n");
			/* 
 			 * 
 			 * Do process */
            
			pf = policy_fired_convert(results);
			
			/* print results */
            if (pf != NULL){
                char *s = timestamp_to_string(pf->tstamp);
                printf( "%s %u %s\n", s, pf->pid, pf->event);
                NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
                FiredEvent *fe = [[FiredEvent alloc] initWithPolicyFiredEvent:pf];
                [[PolicyManager sharedPolicyManager] performSelectorOnMainThread:@selector(policyFired:) withObject:fe waitUntilDone:YES];
                [fe release];
                [autoreleasepool release];
                free(s);
                
                policy_fired_free(pf);
            }
		}
		rtab_free(results);
	}
	return (args) ? NULL : args;	/* unused warning subterfuge */
}

static void *policy_response_handler(void *args) {
    
    printf("in policy response handler\n");
   	char event[SOCK_RECV_BUF_LEN], resp[100];
	char stsmsg[RTAB_MSG_MAX_LENGTH];
	RpcConnection sender;
	unsigned len, rlen;
	
    Rtab *results;
    
	PolicyResponse *pr;
	
    while ((len = rpc_query(responseservice, &sender, event, SOCK_RECV_BUF_LEN)) > 0) {
        
		sprintf(resp, "OK");
		rlen = strlen(resp) + 1;
		rpc_response(responseservice, sender, resp, rlen);
		event[len] = '\0';
		results = rtab_unpack(event, len);
		if (results && ! rtab_status(event, stsmsg)) {
			printf("got response results\n");
			/* 
 			 * 
 			 * Do process */
            
			pr = policy_response_convert(results);
			
			/* print results */
            if (pr != NULL){
                char *s = timestamp_to_string(pr->tstamp);
                printf( "%s %u;%u;%u;%s\n", s, pr->requestid, pr->pid, pr->success, pr->message);
                
                NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
                Response *r = [[Response alloc] initWithPolicyResponse:pr];
                [[PolicyManager sharedPolicyManager] performSelectorOnMainThread:@selector(handlePolicyResponse:) withObject:r waitUntilDone:YES];
                [r release];
                [autoreleasepool release];
                
                free(s);
                policy_response_free(pr);
            }
		}
		rtab_free(results);
	}
	return (args) ? NULL : args;	/* unused warning subterfuge */
}



void policy_free(PolicyData *p){
    if (p) {
        free(p);
    }
}

void policy_response_free(PolicyResponse *p){
    if (p) {
        free(p);
    }
}

void policy_request_free(PolicyRequest *p){
    if (p) {
        free(p);
    }
}

void policy_state_free(PolicyState *p){
    if (p) {
        free(p);
    }
}

void policy_fired_free(PolicyFired *p){
    if (p) {
        free(p);
    }   
}



PolicyData *policy_convert(Rtab *results){
	
    PolicyData *ans;
	
	if (! results || results->mtype != 0){
        printf("returning null as !results!\n");
        return NULL;
        
    }
	
    if (!(ans = (PolicyData *)malloc(sizeof(PolicyData)))){
		printf("returning null as cannot malloc\n");
        return NULL;
    }
	
	//if (results->nrows != 1){
    //   printf("returning null as nrows > 1\n");
    //  return NULL;
    // }
    
    char **columns;
    columns = rtab_getrow(results, 0);
	
    /* populate record */
    ans->tstamp = string_to_timestamp(columns[0]);
    strncpy(ans->action, columns[1], 5);
    ans->identifier = atol(columns[2]);
    strncpy(ans->metadata, columns[3], 256);
    return ans;
    
}



PolicyResponse *policy_response_convert(Rtab *results){
    PolicyResponse *ans;
	
	if (! results || results->mtype != 0){
        printf("returning null as !results!\n");
        return NULL;
        
    }
	
    if (!(ans = (PolicyResponse *)malloc(sizeof(PolicyResponse)))){
		printf("returning null as cannot malloc\n");
        return NULL;
    }
    
    char **columns;
    columns = rtab_getrow(results, 0);
	
    /* populate record */
    ans->tstamp = string_to_timestamp(columns[0]);
    ans->requestid = atol(columns[1]);
    ans->pid = atol(columns[2]);
    ans->success = atol(columns[3]);
    strncpy(ans->message, columns[4], 1024);
    return ans;
}


PolicyRequest *policy_request_convert(Rtab *results){
    PolicyRequest *ans;
	
	if (! results || results->mtype != 0){
        printf("returning null as !results!\n");
        return NULL;
        
    }
	
    if (!(ans = (PolicyRequest *)malloc(sizeof(PolicyRequest)))){
		printf("returning null as cannot malloc\n");
        return NULL;
    }
    
    char **columns;
    columns = rtab_getrow(results, 0);
	
    /* populate record */
    ans->tstamp = string_to_timestamp(columns[0]);
    ans->requestid = atol(columns[1]);
    strncpy(ans->request, columns[2], 8);
    ans->pid = atol(columns[3]);
    strncpy(ans->pondertalk, columns[4], 1024);
    return ans;
}



PolicyState *policy_state_convert(Rtab *results){
    PolicyState *ans;
	
	if (! results || results->mtype != 0){
        printf("returning null as !results!\n");
        return NULL;
        
    }
	
    if (!(ans = (PolicyState *)malloc(sizeof(PolicyState)))){
		printf("returning null as cannot malloc\n");
        return NULL;
    }
    
    char **columns;
    columns = rtab_getrow(results, 0);
	
    /* populate record */
    ans->tstamp = string_to_timestamp(columns[0]);
    ans->pid = atol(columns[1]);
    strncpy(ans->state, columns[2], 8);
    strncpy(ans->pondertalk, columns[4], 1024);
    return ans;
}



PolicyFired *policy_fired_convert(Rtab *results){
    PolicyFired *ans;
	
	if (! results || results->mtype != 0){
        printf("returning null as !results!\n");
        return NULL;
        
    }
	
    if (!(ans = (PolicyFired *)malloc(sizeof(PolicyFired)))){
		printf("returning null as cannot malloc\n");
        return NULL;
    }
    
    char **columns;
    columns = rtab_getrow(results, 0);
	
    /* populate record */
    ans->tstamp = string_to_timestamp(columns[0]);
    ans->pid = atol(columns[1]);
    strncpy(ans->event, columns[2], 512);
    return ans;
}


void dhcp_free(DhcpResults *p) {
	unsigned int i;
	
    if (p) {
        for (i = 0; i < p->nleases && p->data[i]; i++)
            free(p->data[i]);
		free(p->data);	
        free(p);
    }
}


DhcpResults *dhcp_convert(Rtab *results) {
	DhcpResults *ans;
	unsigned int i;
	
	if (! results || results->mtype != 0)
		return NULL;
	if (!(ans = (DhcpResults *)malloc(sizeof(DhcpResults))))
		return NULL;
	
	ans->nleases = results->nrows;
	ans->data    = (DhcpData **)calloc(ans->nleases, sizeof(DhcpData *));
	
	if (!ans->data){
		free(ans);
		return NULL;
	}
	
	for (i = 0; i < ans->nleases; i++) {
		char **columns;
		DhcpData *p = (DhcpData *)malloc(sizeof(DhcpData));
		
		if (!p) {
            dhcp_free(ans);
			return NULL;
		}
		ans->data[i] = p;
		columns = rtab_getrow(results, i);
		/* populate record */
		p->tstamp = string_to_timestamp(columns[0]);
		p->action = action2index(columns[1]);
		p->mac_addr = string_to_mac(columns[2]);
		inet_aton(columns[3], (struct in_addr *)&p->ip_addr);	
		strncpy(p->hostname, columns[4], 70);
	}
	return ans;
}

unsigned int action2index(char *action) {
	if (strcmp(action, "add") == 0)
		return 0;
	else
		if (strcmp(action, "del") == 0)
			return 1;
		else
			if (strcmp(action, "old") == 0)
				return 2;
			else
				if (strcmp(action, "upd") == 0)
					return 3;
	return 4;
}

char *index2action(unsigned int index) {
	if (index == 0)
		return "add";
	else
		if (index == 1)
			return "del";
		else
			if (index == 2)
				return "old";
			else
				if (index == 3)
					return "upd";
    
	return "unknown";
}



-(BOOL) subscribe_to_policy_response:(NSString *) host{
  
        char* query = "PolicyResponseLast";
       responseservicename= "PolicyResponseService";
        responseservice = rpc_offer(responseservicename);
        if (!responseservice){
            fprintf(stderr, "Failure offering %s service\n", responseservicename);
        }
        return [self subscribe:host service:responseservicename query:query handler:policy_response_handler];
    
}

-(BOOL) subscribe_to_policy_fired:(NSString *) host{
    
        char* query = "PolicyFiredLast";
        firedservicename= "PolicyFiredService";

        firedservice = rpc_offer(firedservicename);
        if (! firedservice) {
            fprintf(stderr, "Failure offering %s service\n", firedservicename);
            //exit(-1);
        }
        return [self subscribe:host service:firedservicename query:query handler:policy_fired_handler ];

}




-(BOOL) subscribe: (NSString*) listeninghost service:(char*) s query:(char*) query handler: (void * (void *args)) handler{
    
    
	unsigned rlen;
	char question[1000], resp[100], myhost[100], qname[64], service[100];
	unsigned short myport;
	pthread_t thr;
	
	unsigned short port;
	char *target;
	port = HWDB_SERVER_PORT;
    sprintf(service, s);
    //service = "PolicyMonitorHandler";
	/* initialize the RPC system and offer the Callback service */
	//if (!rpc_init(0)) {
	//	fprintf(stderr, "Initialization failure for rpc system\n");
	//	exit(-1);
    //}
	
    
    
	
    rpc_details(myhost, &myport);
    
    sprintf(myhost, [listeninghost UTF8String]);
    
	printf("my callback port is %05u and host is %s\n", myport, myhost);
    
	/* connect to HWDB service */
	//rpc = rpc_connect(host, port, "HWDB", 1l);
	
    if (rpc == NULL) {
		fprintf(stderr, "Error connecting to HWDB at %s:%05u\n", target, port);
        //		exit(1);
	}
	
	sprintf(qname, query);
	/* subscribe to query 'qname' */
	sprintf(question, "SQL:subscribe %s %s %hu %s", 
            qname, myhost, myport, service);
    
    
    if (!rpc_call(rpc, question, strlen(question)+1, resp, 100, &rlen)) {
        fprintf(stderr, "Error issuing subscribe command\n");
        //exit(1);
    }
    resp[rlen] = '\0';
    printf("Response to subscribe command: %s", resp);
    
    /* start handler thread */
    if (pthread_create(&thr, NULL, handler, NULL)) {
        fprintf(stderr, "Failure to start handler thread\n");
    }

}


-(BOOL) send: (void *) query qlen:(unsigned) qlen resp: (void*) resp rsize:(unsigned) rs len:(unsigned *) len{
	
	if (!connected)
		if (![self connect]){
			connected = FALSE;
			[self performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];
			return FALSE;
		}
	
	if (rpc){
		@synchronized(rpc){
			if (rpc_call(rpc, query, qlen, resp, rs, len)){
				return TRUE;
			}else{
				rpc_disconnect(rpc);
				connected = FALSE;
				[self performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];
			}
		}
	}
	return FALSE;
}

-(void) notifydisconnected:(NSObject *) o{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"disconnected" object:nil];
}

-(void) notifyconnected:(NSObject *) o{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"connected" object:nil];
}

uint64_t string_to_mac(char *s) {
    int b[6], i;
    uint64_t ans;
	
    sscanf(s, "%02x:%02x:%02x:%02x:%02x:%02x",
		   &b[0], &b[1], &b[2], &b[3], &b[4], &b[5]);
    ans = 0LL;
    for (i = 0; i < 6; i++)
        ans = ans << 8 | (b[i] & 0xff);
    return ans;
}




@end
