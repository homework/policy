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
static int sig_received;
static RpcService rps;


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


-(BOOL) connect{
	NSLog(@"connecting to router %s, %d", host, port);
	rpc = rpc_connect(host, port, "HWDB", 1l);
	if (rpc){
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



static void *handler(void *args) {
    
   	char event[SOCK_RECV_BUF_LEN], resp[100];
	char stsmsg[RTAB_MSG_MAX_LENGTH];
	RpcConnection sender;
	unsigned len, rlen;
	
    Rtab *results;
    
	PolicyData *pd;
	
    while ((len = rpc_query(rps, &sender, event, SOCK_RECV_BUF_LEN)) > 0) {

		sprintf(resp, "OK");
		rlen = strlen(resp) + 1;
		rpc_response(rps, sender, resp, rlen);
		event[len] = '\0';
		results = rtab_unpack(event, len);
		if (results && ! rtab_status(event, stsmsg)) {
			printf("got results\n");
			/* 
 			 * 
 			 * Do process */
            
			pd = policy_convert(results);
			
			/* print results */
            if (pd != NULL){
                char *s = timestamp_to_string(pd->tstamp);
                printf( "%s %s;%lu;%s\n", s, pd->action, pd->identifier, pd->metadata);
            
                free(s);
                policy_free(pd);
            }else{
                printf("got a load of rows...");
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


static void signal_handler(int signum) {
	sig_received = signum;
}

-(BOOL) subscribe: (NSString*) listeninghost query:(char*) query{
   
    
	unsigned rlen;
	char question[1000], resp[100], myhost[100], qname[64];
	unsigned short myport;
	pthread_t thr;
	
	unsigned short port;
	char *target;
	char *service;
    
	//sigset_t mask, oldmask;
    
	//target = HWDB_SERVER_ADDR;
	port = HWDB_SERVER_PORT;
    
	
    service = "PolicyMonitorHandler";
	/* initialize the RPC system and offer the Callback service */
	if (!rpc_init(0)) {
		fprintf(stderr, "Initialization failure for rpc system\n");
	//	exit(-1);
	}
	
    rps = rpc_offer(service);
	
    if (! rps) {
		fprintf(stderr, "Failure offering %s service\n", service);
		//exit(-1);
	}
	
    rpc_details(myhost, &myport);
    
    sprintf(myhost, [listeninghost UTF8String]);
    
	printf("my callback port is %05u and host is %s\n", myport, myhost);
    
	/* connect to HWDB service */
	rpc = rpc_connect(host, port, "HWDB", 1l);
	
    if (rpc == NULL) {
		fprintf(stderr, "Error connecting to HWDB at %s:%05u\n", target, port);
		exit(1);
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
		//exit(-1);
	}
    
    
	/*	if (signal(SIGTERM, signal_handler) == SIG_IGN)
		signal(SIGTERM, SIG_IGN);
	if (signal(SIGINT, signal_handler) == SIG_IGN)
		signal(SIGINT, SIG_IGN);
	if (signal(SIGHUP, signal_handler) == SIG_IGN)
		signal(SIGHUP, SIG_IGN);
    
	sigemptyset(&mask);
	sigaddset(&mask, SIGINT);
	sigaddset(&mask, SIGHUP);
	sigaddset(&mask, SIGTERM);
	// suspend until signal 
	sigprocmask(SIG_BLOCK, &mask, &oldmask);
	while (!sig_received)
		sigsuspend(&oldmask);
	sigprocmask(SIG_UNBLOCK, &mask, NULL);
	
	// issue unsubscribe command 
	sprintf(question, "SQL:unsubscribe %s %s %hu %s", 
            qname, myhost, myport, service);
	if (!rpc_call(rpc, question, strlen(question)+1, resp, 100, &rlen)) {
		fprintf(stderr, "Error issuing unsubscribe command\n");
		exit(1);
	}
	resp[rlen] = '\0';
	printf("Response to unsubscribe command: %s", resp);
    
	// disconnect from server 
	rpc_disconnect(rpc);    */
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
