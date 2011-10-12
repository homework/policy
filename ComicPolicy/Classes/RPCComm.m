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
-(void) subscribe: (NSString*) listeninghost service:(char*) service query:(char*) query handler: (void * (void *args)) handler;
-(void) unsubscribe:(NSString *) listeninghost service:(char*) s  query:(char*) query;

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
NSString* callbackaddr;

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

-(id) init{
    self = [super init];
    
    if (self != nil) {
       
    }
    return self;
}

-(void) setSetUpHWDBConnection:(NSString *) gwaddr callback:(NSString *) cb{
    port = 987;
    
    NSLog(@"WIFI IP ADDR IS %@",gwaddr);
    callbackaddr = cb;
    
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


-(BOOL) connect{
	NSLog(@"connecting to router %s, %d", host, port);
	rpc = rpc_connect(host, port, "HWDB", 1l);
	if (rpc){
        connected = TRUE;
        [self subscribe_to_policy_fired];
        [self subscribe_to_policy_response];
       
		[self performSelectorOnMainThread:@selector(notifyconnected:) withObject:nil waitUntilDone:NO];
		return TRUE;
	}
    NSLog(@"failed to connect........");
	[self performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];

    return FALSE;
}


-(void) getStoredPolicies{
     NSString* statequery = [NSString stringWithFormat:@"SQL:select * from PolicyState WHERE state contains \"BLED\")\n"];
    sprintf(sendquery, [statequery UTF8String]);
	querylen = strlen(sendquery) + 1;
    [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:length callback:processpolicystateresults];
    
    
    NSString* firedquery = [NSString stringWithFormat:@"SQL:select * from PolicyFired WHERE state contains \"FIRED\")\n"];
    sprintf(sendquery, [firedquery UTF8String]);
	querylen = strlen(sendquery) + 1;
    [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:length callback:processfiredresults];
}



-(void) getIsUsedFor:(NSString *) ipaddr{
    
    NSString* query;
    
    if ([ipaddr isEqualToString:@"*"]){
         query = [NSString stringWithFormat:@"SQL:select t, sum(nbytes) from KFlows [range 5 seconds]\n"];
    }
    else{
        query = [NSString stringWithFormat:@"SQL:select t, sum(nbytes) from KFlows [range 5 seconds] WHERE saddr = \"%@\" or daddr = \"%@\"\n", ipaddr, ipaddr];
    }
    
    sprintf(sendquery, [query UTF8String]);
	 querylen = strlen(sendquery) + 1;
     [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:length callback:processflowresults];
}

-(void) getCumulativeBandwidthFor:(NSString *) ipaddr{
    /*
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"yyyy-M-d HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    
    NSString* newdate = [NSString stringWithFormat:@"%d-%d-1 00:00:00", [components year], [components month]];
    
    NSLog(@"new date is %@", newdate);
    
    NSDate* since = [df dateFromString:newdate];
    
    NSLog(@"created date %@", since);
    
    NSTimeInterval ti = [since timeIntervalSince1970];
    
    NSLog(@"unix ts is %f", ti); 
    */
    NSString* query;
    
    if ([ ipaddr isEqualToString: @"*"]){
        query = [NSString stringWithFormat:@"SQL:select sum(nbytes) from BWUsage\n"];
    }else{
        query = [NSString stringWithFormat:@"SQL:select nbytes from BWUsage where ip = \"%@\"\n", ipaddr]; 
    }
    
    NSLog(@"sending query: %@", query);
    
    /*NSString* subnet = @"10.2.1";
    
    NSString* query = [NSString stringWithFormat:@"SQL:select sum(nbytes) from Flows [since %@] where daddr contains \"%@\" and saddr notcontains \"%@\"",ti, ipaddr, subnet];*/
   
     
    sprintf(sendquery, [query UTF8String]);
	
    querylen = strlen(sendquery) + 1;
    
    [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:length callback:processusageresults];
}


-(void) getHouseholdAllowance{
    NSString* query = [NSString stringWithFormat:@"SQL:select allowance from Allowances\n"]; 
    sprintf(sendquery, [query UTF8String]);
	
    querylen = strlen(sendquery) + 1;
    
    [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:length callback:processallowanceresults];

}

-(void) getURLsBrowsedBy:(NSString*) ipaddr{
    NSString* query = [NSString stringWithFormat:@"SQL:select * from Urls [range 5 seconds] where saddr contains \"%@\" order by hst asc\n", ipaddr];
    
    
    sprintf(sendquery, [query UTF8String]);
	querylen = strlen(sendquery) + 1;
    [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:length callback:processurlesults];    
}

-(void) query:(NSString *)q{
	sprintf(sendquery, [q UTF8String]);
	querylen = strlen(sendquery) + 1;
    [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:length callback:NULL];
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

void policy_fired_results_free(FiredResults *p){
    unsigned int i;
	
    if (p) {
        for (i = 0; i < p->nfired && p->data[i]; i++)
            free(p->data[i]);
		free(p->data);	
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
    strncpy(ans->state, columns[2], 10);
    strncpy(ans->event, columns[3], 512);
    return ans;
}

FiredResults *policy_fired_results_convert(Rtab *results){

    
    FiredResults *ans;
	unsigned int i;
	
	if (! results || results->mtype != 0)
		return NULL;
	if (!(ans = (FiredResults *)malloc(sizeof(FiredResults))))
		return NULL;
	
	ans->nfired = results->nrows;
	ans->data    = (PolicyFired **)calloc(ans->nfired, sizeof(PolicyFired *));
	
	if (!ans->data){
		free(ans);
		return NULL;
	}
	
	for (i = 0; i < ans->nfired; i++) {
		char **columns;
		PolicyFired *pf = (PolicyFired *)calloc(1,sizeof(PolicyFired));
		
		if (!pf) {
            policy_fired_results_free(ans);
			return NULL;
		}
		ans->data[i] = pf;
		columns = rtab_getrow(results, i);
		/* populate record */
		pf->tstamp = string_to_timestamp(columns[0]);
        pf->pid = atol(columns[1]);
        strncpy(pf->state, columns[2], 10);
        strncpy(pf->event, columns[3], 512);
	}
	return ans;
}


PolicyStateResults *policy_state_convert(Rtab *results) {
	PolicyStateResults *ans;
	unsigned int i;
	
	if (! results || results->mtype != 0)
		return NULL;
	if (!(ans = (PolicyStateResults *)malloc(sizeof(PolicyStateResults))))
		return NULL;
	
	ans->npolicies = results->nrows;
	ans->data    = (PolicyState **)calloc(ans->npolicies, sizeof(PolicyState *));
	
	if (!ans->data){
		free(ans);
		return NULL;
	}
	
	for (i = 0; i < ans->npolicies; i++) {
		char **columns;
		PolicyState *ps = (PolicyState *)calloc(1,sizeof(PolicyState));
		
		if (!ps) {
            policy_state_results_free(ans);
			return NULL;
		}
		ans->data[i] = ps;
		columns = rtab_getrow(results, i);
		/* populate record */
		ps->tstamp = string_to_timestamp(columns[0]);
        ps->pid = atol(columns[1]);
        strncpy(ps->state, columns[2], 8);
        strncpy(ps->pondertalk, columns[3], 1024);
	}
	return ans;
}

void policy_state_results_free(PolicyStateResults *p) {
	unsigned int i;
	
    if (p) {
        for (i = 0; i < p->npolicies && p->data[i]; i++)
            free(p->data[i]);
		free(p->data);	
        free(p);
    }
}


long long usage_convert(Rtab *results){
    if (! results || results->mtype != 0)
		return 0;
     long long bytes = 0;
    
     if (results->nrows >= 1){
         char **columns;
         columns = rtab_getrow(results, 0);
        
         bytes = atoll(columns[0]);
         NSLog(@"got back %llu bytes", bytes); 
     }
    return bytes;
}


tstamp_t processusageresults(char *buf, unsigned int len) {
    
    Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
    unsigned long long bytes;

	tstamp_t last = timestamp_now();
    results = rtab_unpack(buf, len);
    
	if (results && ! rtab_status(buf, stsmsg)) {
		bytes = usage_convert(results);
        NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
        [[RPCComm sharedRPCComm] performSelectorOnMainThread:@selector(notifyUsage:) withObject:[NSNumber numberWithLongLong:bytes] waitUntilDone:YES];
        [autoreleasepool release];

    }
    rtab_free(results);
	
    return (last);
}

-(void) notifyUsage:(NSNumber *)bytes{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newUsageData" object:bytes];
}


long long allowance_convert(Rtab *results){
    if (! results || results->mtype != 0)
		return 0;
    long long bytes = 0;
    
    if (results->nrows >= 1){
        char **columns;
        columns = rtab_getrow(results, 0);
        NSLog(@"ALLOWANCES got %s", columns[0]);
        bytes = atoll(columns[0]);
    }
    return bytes;
}


tstamp_t processallowanceresults(char *buf, unsigned int len) {
    
    Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
    long long bytes;
    
	tstamp_t last = timestamp_now();
    results = rtab_unpack(buf, len);
    
	if (results && ! rtab_status(buf, stsmsg)) {
		bytes = allowance_convert(results);
        NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
        NSLog(@"******* setting allowance to %llu", bytes);
        [[Catalogue sharedCatalogue] performSelectorOnMainThread:@selector(setAllowance:) withObject:[NSNumber numberWithLongLong:bytes] waitUntilDone:YES];
        [autoreleasepool release];
    }
    rtab_free(results);
	
    return (last);
}


 UsageData* flow_convert(Rtab *results){
     
     UsageData *ud = [[[UsageData alloc] init] autorelease];
     ud.ts      =0L;
     ud.bytes   =0L;
     
    if (! results || results->mtype != 0)
		return nil;
   
     
    if (results->nrows >= 1){
        
        char **columns;
        columns = rtab_getrow(results, 0);
        tstamp_t ts = string_to_timestamp(columns[0]);
        long bytes  = atol(columns[1]);
        ud.ts = ts;
        ud.bytes = bytes;
        return ud;
    }
    return ud;
}

tstamp_t processfiredresults(char *buf, unsigned int len){
   	Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
    FiredResults *fr;
    unsigned long i;
	tstamp_t last = timestamp_now();
    results = rtab_unpack(buf, len);
    
	if (results && ! rtab_status(buf, stsmsg)) {
		// rtab_print(results);
		fr = policy_fired_results_convert(results);
		// do something with the data pointed to by p 
        
		NSLog(@"Retrieved %ld policy fired records from database\n", fr->nfired);
        
		for (i = 0; i < fr->nfired; i++) {
			PolicyFired *pf = fr->data[i];
            char *s = timestamp_to_string(pf->tstamp);
            printf( "%s %u %s\n", s, pf->pid, pf->event);
            
            NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
            FiredEvent *fe = [[FiredEvent alloc] initWithPolicyFiredEvent:pf];
            [[PolicyManager sharedPolicyManager] performSelectorOnMainThread:@selector(policyFired:) withObject:fe waitUntilDone:YES];
            [fe release];
            [autoreleasepool release];
            free(s); 
        }
		policy_fired_results_free(fr);
    }
    rtab_free(results);
	
    return (last);
}


tstamp_t processflowresults(char *buf, unsigned int len) {
    
    Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
     
	tstamp_t last = timestamp_now();
    results = rtab_unpack(buf, len);
    
	if (results && ! rtab_status(buf, stsmsg)) {
		UsageData* ud = flow_convert(results);
       // NSLog(@"got %lu bytes\n", ud.bytes);
        NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
        [[RPCComm sharedRPCComm] performSelectorOnMainThread:@selector(notifyActivity:) withObject:ud waitUntilDone:YES];
        [autoreleasepool release];
    }
    
    rtab_free(results);
	
    return (last);
}

-(void) notifyActivity:(NSNumber *)bytes{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newActivityData" object:bytes];
}

tstamp_t processpolicystateresults(char *buf, unsigned int len) {
	
	Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
    PolicyStateResults *psr;
    unsigned long i;
	tstamp_t last = timestamp_now();
    results = rtab_unpack(buf, len);
    
	if (results && ! rtab_status(buf, stsmsg)) {
		// rtab_print(results);
		psr = policy_state_convert(results);
		// do something with the data pointed to by p 
        
		NSLog(@"Retrieved %ld policy records from database\n", psr->npolicies);
        NSMutableArray *policies = [[NSMutableArray alloc] initWithCapacity:psr->npolicies];
        
		for (i = 0; i < psr->npolicies; i++) {
			PolicyState *ps = psr->data[i];
			
			char *s = timestamp_to_string(ps->tstamp);
			
			printf("pf readin policy %s and  %s\n", ps->state , ps->pondertalk);
			PolicyStateObject *psobj = [[[PolicyStateObject alloc] initWithPolicyState:ps] autorelease];
            NSLog(@"ns read in a policy %d %@ %@\n", psobj.pid, psobj.state, psobj.pondertalk);
            [policies addObject:psobj];
			//[psobj release];
            free(s);
        }
		policy_state_results_free(psr);
        
        NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
        [[PolicyManager sharedPolicyManager] performSelectorOnMainThread:@selector(setUpWithPolicies:) withObject:policies waitUntilDone:YES];
        [policies release];
        [autoreleasepool release];

    }
    rtab_free(results);
	
    return (last);
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


void url_results_free(UrlResults *ur){
    unsigned int i;
	
    if (ur) {
        for (i = 0; i < ur->nurls && ur->data[i]; i++)
            free(ur->data[i]);
		free(ur->data);	
        free(ur);
    }
}

UrlResults *url_convert(Rtab* results){
    UrlResults *ans;
	unsigned int i;
	
	if (! results || results->mtype != 0)
		return NULL;
	if (!(ans = (UrlResults *)malloc(sizeof(UrlResults))))
		return NULL;
	
	ans->nurls= results->nrows;
	ans->data    = (Url **)calloc(ans->nurls, sizeof(Url *));
	
	if (!ans->data){
		free(ans);
		return NULL;
	}
	
	for (i = 0; i < ans->nurls; i++) {
		char **columns;
		Url *u = (Url *)calloc(1,sizeof(Url));
		
		if (!u) {
            url_results_free(ans);
			return NULL;
		}
		ans->data[i] = u;
		columns = rtab_getrow(results, i);
        
		/* populate record */
		u->tstamp = string_to_timestamp(columns[0]);
        u->proto = atoi(columns[1]) & 0xff;
		inet_aton(columns[2], (struct in_addr *)&u->saddr);
		u->sport = atoi(columns[3]) & 0xffff;
		inet_aton(columns[4], (struct in_addr *)&u->daddr);
		u->dport = atoi(columns[5]) & 0xffff;
        strncpy(u->hst, columns[6], 128);
        strncpy(u->uri, columns[7], 128);
        strncpy(u->cnt, columns[8], 128);
	}
	return ans;

}

tstamp_t processurlesults(char *buf, unsigned int len){
    Rtab *results;
    char stsmsg[RTAB_MSG_MAX_LENGTH];
    UrlResults *p;
    unsigned long i;
    tstamp_t last = 0LL;	
    results = rtab_unpack(buf, len);
    
	if (results && ! rtab_status(buf, stsmsg)) {
        p = url_convert(results);
		// do something with the data pointed to by p 
		//NSLog(@"Retrieved %ld url records from database", p->nurls);
		
		for (i = 0; i < p->nurls; i++) {
			Url *u = p->data[i];
			char *s = timestamp_to_string(u->tstamp);
			NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
			URLObject *urlobj = [[URLObject alloc] initWithUrl:u];
			[[RPCComm sharedRPCComm] performSelectorOnMainThread:@selector(postUrlData:) withObject:urlobj waitUntilDone:YES];
			[urlobj release];
			[autoreleasepool release];		
			
			free(s);
		}
		if (i > 0) {
			i--;
			last = p->data[i]->tstamp;
		}
		url_results_free(p);
    }
    rtab_free(results);
    return (last);
}

-(void) postUrlData:(URLObject *) u{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newVisitsData" object:u];
}

-(void) subscribe_to_policy_response{
  
        char* query = "PolicyResponseLast";
       responseservicename= "PolicyResponseService";
        responseservice = rpc_offer(responseservicename);
        if (!responseservice){
            fprintf(stderr, "Failure offering %s service\n", responseservicename);
        }
         [self subscribe:callbackaddr service:responseservicename query:query handler:policy_response_handler];
    
}

-(void) subscribe_to_policy_fired{
    
        char* query = "PolicyFiredLast";
        firedservicename= "PolicyFiredService";

        firedservice = rpc_offer(firedservicename);
        if (! firedservice) {
            fprintf(stderr, "Failure offering %s service\n", firedservicename);
            //exit(-1);
        }
         [self subscribe:callbackaddr service:firedservicename query:query handler:policy_fired_handler ];

}


-(void) unsubscribe_from_policy_fired{
    char* query = "PolicyResponseLast";
    firedservicename= "PolicyFiredService";
    [self unsubscribe:callbackaddr service:firedservicename query:query];
}

-(void) unsubscribe_from_policy_response{
    char* query = "PolicyFiredLast";
    firedservicename= "PolicyResponseService";
    [self unsubscribe:callbackaddr service:firedservicename query:query];
}



-(void) unsubscribe:(NSString *) listeninghost service:(char*) s  query:(char*) query{
    unsigned rlen;
	char question[1000], resp[100], myhost[100], qname[64], service[100];
	unsigned short myport;
	
	unsigned short port;
	char *target;
	port = HWDB_SERVER_PORT;
    sprintf(service, s);
	
    rpc_details(myhost, &myport);
    
    sprintf(myhost, [listeninghost UTF8String]);
    
    if (rpc == NULL) {
		fprintf(stderr, "Error connecting to HWDB at %s:%05u\n", target, port);
        //		exit(1);
	}
	
	sprintf(qname, query);
	/* subscribe to query 'qname' */
	sprintf(question, "SQL:unsubscribe %s %s %hu %s", qname, myhost, myport, service);
    
    if (!rpc_call(rpc, question, strlen(question)+1, resp, 100, &rlen)) {
        fprintf(stderr, "Error issuing subscribe command\n");
        //exit(1);
    }
    resp[rlen] = '\0';
    printf("Response to unsubscribe command: %s", resp);

}



-(void) subscribe: (NSString*) listeninghost service:(char*) s query:(char*) query handler: (void * (void *args)) handler{
    
    
	unsigned rlen;
	char question[1000], resp[100], myhost[100], qname[64], service[100];
	unsigned short myport;
	pthread_t thr;
	
	unsigned short port;
	char *target;
	port = HWDB_SERVER_PORT;
    sprintf(service, s);
	
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
	sprintf(question, "SQL:subscribe %s %s %hu %s", qname, myhost, myport, service);
    
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


-(void) send: (void *) query qlen:(unsigned) qlen resp: (void*) resp rsize:(unsigned) rs len:(unsigned int) len callback: (tstamp_t (char *buf, unsigned int len)) callback{
	
	if (!connected)
		if (![self connect]){
			connected = FALSE;
			[self performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];
		}
	
	if (rpc){
		@synchronized(rpc){
			if (rpc_call(rpc, query, qlen, resp, rs, &len)){
                connected=TRUE;
                if (callback != NULL)
                    callback(resp, len);
			}else{
				//[self closeHWDBConnection];
                //connected = FALSE;
				[self performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];
               
			}
		}
	}
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


-(void) closeHWDBConnection{
    [self unsubscribe_from_policy_fired];
    [self unsubscribe_from_policy_response];
    rpc_disconnect(rpc);
}





@end
