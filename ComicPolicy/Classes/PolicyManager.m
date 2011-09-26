//
//  PolicyManager.m
//  ComicPolicy
//
//  Created by Tom Lodge on 04/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PolicyManager.h"
#import "JSON.h"
#import "Catalogue.h"
#import "NetworkManager.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "Policy.h"
#import "RPCComm.h"
#import "Response.h"
#import "FiredEvent.h"
#import "PolicyStateObject.h"
#import "RequestObject.h"

@interface PolicyManager()
-(void) readInPolicies:(NSMutableDictionary *) policydict;
-(void) newDefaultPolicy;
-(void) saveCurrentPolicy;
-(void) readPoliciesFromFile;
-(void) createSnapshot:(Policy*) p;

-(int) registerRequest:(NSString *) lid type:(RequestType) type request:(NSString*) request;
-(RequestObject *) getRequestObjectFor:(int) requestid;

-(NSString *) encodePolicyForDatabase:(NSString *)policy;
-(NSString *) decodePolicyFromDatabase:(NSString *)policy;

@end

@implementation PolicyManager

@synthesize policyids;
@synthesize policies;
@synthesize currentPolicy;
@synthesize defaultPolicy;

static int localId;
static int requestId;

+ (PolicyManager *)sharedPolicyManager
{
    static  PolicyManager * sPolicyManager;
    
    if (sPolicyManager == nil) {
        @synchronized (self) {
            sPolicyManager = [[PolicyManager alloc] init];
            assert(sPolicyManager != nil);
        }
    }
    return sPolicyManager;
}

- (id)init
{
    // any thread, but serialised by +sharedPolicyManager
    self = [super init];
    if (self != nil) {
        localId = 1;
        requestId = 1;
        
        localLookup    = [[[NSMutableDictionary alloc] init] retain];
        requesttable   = [[[NSMutableDictionary alloc] init] retain];
        self.policies  = [[NSMutableDictionary alloc] init];
        self.policyids = [[NSMutableArray alloc] init];
        //[self readPoliciesFromFile];
    }
    return self;
}

-(void) setUpWithPolicies:(NSMutableArray *) policystateobjects{
    for (PolicyStateObject* pso in policystateobjects){
        Policy *p = [[Policy alloc] initWithPonderString:[self decodePolicyFromDatabase:pso.pondertalk]];
        NSString* policylid = [NSString stringWithFormat:@"%d",localId];
        NSString* policygid = [NSString stringWithFormat:@"%d",pso.pid];
        [p updateStatus:pso.state];
        p.localid  = policylid;
        p.identity = policygid;
        [policies setObject:p forKey:policylid];
        [policyids addObject:policylid];
        [localLookup setObject:policygid forKey:policylid];
        localId++;
    }
}

-(void) readPoliciesFromFile{
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ponderpolicies" ofType:@"txt"];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath];
    
    NSScanner *scanner = [NSScanner scannerWithString:content];
    
    
    while ([scanner isAtEnd] == NO){
        NSLog(@"READING IN POLICY FROM FILE");
        NSString *pstring;
        [scanner scanUpToString:@"\n\n" intoString:&pstring];
        Policy *p = [[Policy alloc] initWithPonderString:pstring];
        NSString* policyid = [NSString stringWithFormat:@"%d",localId];
        [p setLocalid:policyid];
        [policies setObject:p forKey:policyid];
        [policyids addObject:policyid];
        localId++;
    }

    [self loadFirstPolicy];
}


-(NSString*) currentPolicyId{
    return currentPolicy.identity;
}

-(NSString*) currentLocalPolicyId{
    return currentPolicy.localid;
}

-(BOOL) hasFired{
    return currentPolicy.fired;
}

-(BOOL) hasFiredForSubject:(NSString *)subject{
    if (currentPolicy.fired){
        if ([currentPolicy.actionsubject isEqualToString:subject]){
            return YES;
        }
    }
    return NO;
}

/*
 * Check to see if the current catalogue selections are in sync with the saved policy
 */

-(BOOL) isInSync{
    
    if (currentPolicy.identity == NULL){
        return NO;
    }
    
    
    if ( ![currentPolicy.subjectdevice isEqualToString:[[Catalogue sharedCatalogue] currentSubjectDevice]])
        return NO;
    
    
    if (![currentPolicy.conditiontype isEqualToString: [[Catalogue sharedCatalogue] currentCondition]])
        return NO;
    
    //TODO: condition args...
   if ( ![currentPolicy.actiontype isEqualToString: [[Catalogue sharedCatalogue] currentActionType]])
        return NO;
    
   if (![currentPolicy.actionsubject isEqualToString: [[Catalogue sharedCatalogue] currentActionSubject]])
        return NO;
    
    //TODO: actionargs....
    
    return YES;
}

-(void) readInPolicies:(NSMutableDictionary *)policydict{
    
    for (NSString *identity in [policydict allKeys]){
            
        Policy *apolicy = [[Policy alloc] initWithDictionary:[policydict objectForKey:identity]];
        
        NSString* localid = [NSString stringWithFormat:@"%d", localId];
        [apolicy setIdentity:identity];
        [apolicy setLocalid:localid];
        
        [self.policies setValue:apolicy forKey:[NSString stringWithFormat:@"%d", localId]];
        
        [localLookup setValue:localid forKey:identity];
        
        [apolicy release];
        
        localId++;
    }
}

-(void) loadFirstPolicy{
    
    if (self.policyids != nil && [policyids count] > 0){ 
        [self loadPolicy:[policyids objectAtIndex:0]];
        self.defaultPolicy = [[Policy alloc] initWithPolicy:currentPolicy];
    }else{
        [self readPoliciesFromFile];
    }
}


-(NSMutableDictionary *) getConditionArguments:(NSString*)type{
   
    if ([currentPolicy.conditiontype isEqualToString:type]){
        return currentPolicy.conditionarguments;
    }
    return nil;
}


-(void) newDefaultPolicy{
   
    Policy *apolicy  = [[Policy alloc] initWithPolicy:defaultPolicy];

    apolicy.status = unsaved;
    
    [apolicy setLocalid:[NSString stringWithFormat:@"%d",localId++]];

    [policies setObject:apolicy forKey:apolicy.localid];
    
    [policyids addObject:apolicy.localid];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"totalPoliciesChanged" object:nil userInfo:nil];
}

-(void) refresh{
    if (currentPolicy.identity != NULL){
        [self loadPolicy:currentPolicy.localid];
    }
}

-(void) reset{
    [self savePolicy];
}

-(void) loadPolicy:(NSString*) localpolicyid{

    Policy *apolicy = [policies objectForKey:localpolicyid];
    
    if (apolicy != nil){
        NSLog(@"LOADED:");
        [apolicy print];
        
        [[Catalogue sharedCatalogue]  setSubjectDevice:apolicy.subjectdevice];
        
        [[Catalogue sharedCatalogue] setCondition:apolicy.conditiontype options:apolicy.conditionarguments];
       
        [[Catalogue sharedCatalogue] setAction:apolicy.actiontype subject:apolicy.actionsubject options:apolicy.actionarguments];
    
        self.currentPolicy = apolicy;
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"policyLoaded" object:nil userInfo:nil];
}


-(void) policyFired:(FiredEvent *) event{
    NSLog(@"POLICY FIRED>>>>>>>>> global policy id %d", event.pid);
   
    NSString *localid = [localLookup objectForKey: [NSString stringWithFormat:@"%d", event.pid]];
    
    NSLog(@"localpolicy id is  %@", localid);
    
    [self loadPolicy:localid];
    
    currentPolicy.fired = YES;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:localid forKey:@"identity"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"policyFired" object:nil userInfo:dict];
    
    //dict release??
}


-(NSString *) encodePolicyForDatabase:(NSString *)policy{
    
    NSError *error = NULL;
    
    NSRegularExpression *quoteregex = [NSRegularExpression regularExpressionWithPattern:@"\"" options:NSRegularExpressionCaseInsensitive error:&error];
    
    policy = [quoteregex stringByReplacingMatchesInString:policy options:0 range:NSMakeRange(0, [policy length]) withTemplate:@"\\^"];
    
    return policy;
}

-(NSString *) decodePolicyFromDatabase:(NSString *)policy{
    NSError *error = NULL;
    
    NSRegularExpression *atregex = [NSRegularExpression regularExpressionWithPattern:@"\\^" options:NSRegularExpressionCaseInsensitive error:&error];
    
    policy = [atregex stringByReplacingMatchesInString:policy options:0 range:NSMakeRange(0, [policy length]) withTemplate:@"\""];
    
    return policy;
}

-(NSString *) createPonderTalk{
    [self saveCurrentPolicy];
      return @"";
}

-(void) handlePolicyResponse:(Response *) pr{
    
        
        /*
         * Reconstruct the policy from the message and then save representation. 
         */
    
        RequestObject *robj = [self getRequestObjectFor:pr.requestid];
    
        
        if (robj.requestType == requestCreate || robj.requestType == requestEnable){
            
            
            NSString* ponderString = robj.requestString;
            Policy *tosave = [[Policy alloc] initWithPonderString:ponderString];
            tosave.localid  = robj.localId;
            tosave.identity = [NSString stringWithFormat:@"%d",pr.pid];
            tosave.status = disabled;
            
            if (robj.requestType == requestEnable){
                tosave.status = enabled;
            }
            
            [tosave print];
            
            [localLookup setObject:tosave.localid forKey:tosave.identity];
            
            [policies setObject:tosave forKey:tosave.localid];
            [self loadPolicy:tosave.localid];
        }     
    
        [robj release];
}


-(void) deleteCurrentPolicy{
   
    
    if ([policyids count] > 1){
    
  
        [policies removeObjectForKey:currentPolicy.localid];
        [policyids removeObjectIdenticalTo:currentPolicy.localid];
        [currentPolicy release];
        [self loadPolicy:[policyids objectAtIndex:0]];
    }
     //[[NSNotificationCenter defaultCenter] postNotificationName:@"totalPoliciesChanged" object:nil userInfo:nil];
}


-(void) enablePolicy{
    NSString *policystr = [currentPolicy toPonderString];
    int requestid = [self registerRequest:currentPolicy.localid type:requestEnable request:policystr];

    policystr = [self encodePolicyForDatabase:policystr];
    int identity = [currentPolicy.identity isEqualToString:@"-1"] ? 0 :[currentPolicy.identity intValue];
    
    NSString* query = [NSString stringWithFormat:@"SQL:insert into PolicyRequest values ('%d', \"%@\", '%d', \"%@\")\n", requestid, @"ENABLE", identity, policystr];
    
    [[RPCComm sharedRPCComm] sendquery:query];

}


-(void) savePolicyToHWDB{
   
    Policy *p = [[Policy alloc] init];
    
    [self createSnapshot:p];
    
        
    NSString *policystr = [p toPonderString];
    
    int requestid = [self registerRequest:p.localid type:requestCreate request:policystr];
    
    policystr = [self encodePolicyForDatabase:policystr];

    
    int identity = [p.identity isEqualToString:@"-1"] ? 0 :[p.identity intValue];
    

    
    
    
    NSString* query = [NSString stringWithFormat:@"SQL:insert into PolicyRequest values ('%d', \"%@\", '%d', \"%@\")\n", requestid, @"CREATE", identity, policystr];
    
  
    
   
    [[RPCComm sharedRPCComm] sendquery:query];
    [p release];

}


-(RequestObject *) getRequestObjectFor:(int) requestid{
    NSString *key = [NSString stringWithFormat:@"%d", requestid];
    RequestObject *reqobj = [requesttable objectForKey:key];
    [requesttable removeObjectForKey:key];
    return reqobj;
}

-(int) registerRequest:(NSString *) lid type:(RequestType) type request:(NSString*)requeststr {
    int rid = requestId++;
    RequestObject *reqobj = [[RequestObject alloc] initWithValues: lid type: type request:requeststr];
    [requesttable setObject: reqobj forKey:[NSString stringWithFormat:@"%d",rid]];
    return rid;
}


-(void) deleteAll{
    NSString *rootURL  = [[NetworkManager sharedManager] rootURL];
    NSString *strurl = [NSString stringWithFormat:@"%@/policy/delete", rootURL];
    
    NSURL *url = [NSURL URLWithString:strurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:@"" forKey:@"policy"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(policyDeleteComplete:)];
    [request setDidFailSelector:@selector(delegateFailed:)];
    [[NetworkManager sharedManager] addRequest:request]; 
}

- (void)policyDeleteComplete:(ASIHTTPRequest *)request{
  
    [policies removeAllObjects];
    [policyids removeAllObjects];
    [localLookup release];
    [policies release];
    [policyids release];
    //[self createDefaultStartPolicy];
}

- (void)addedRequestComplete:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *data  = (NSDictionary *) [jsonParser objectWithString:responseString error:nil];
  
    
    if ([[data objectForKey:@"result"] isEqualToString:@"success"]){
        currentPolicy.identity = [data objectForKey:@"message"];
        [localLookup setObject: currentPolicy.localid  forKey: currentPolicy.identity];
        [self saveCurrentPolicy];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveRequestComplete" object:nil userInfo:nil];
}

- (void)delegateFailed:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"saveRequestComplete" object:nil userInfo:nil];
}

-(void) saveCurrentPolicy{
    currentPolicy.subjectdevice = [[Catalogue sharedCatalogue] currentSubjectDevice];
    
    currentPolicy.conditiontype      = [[Catalogue sharedCatalogue] currentCondition];
    currentPolicy.conditionarguments = [[Catalogue sharedCatalogue] conditionArguments];
    
    currentPolicy.actionarguments   = [[Catalogue sharedCatalogue] actionArguments];
    currentPolicy.actionsubject     = [[Catalogue sharedCatalogue] currentActionSubject];
    currentPolicy.actiontype        = [[Catalogue sharedCatalogue] currentActionType];
    currentPolicy.fired = NO;
}

-(void)createSnapshot: (Policy*) p{
    p.identity           = currentPolicy.identity;
    p.localid            = currentPolicy.localid;
    p.subjectdevice      = [[Catalogue sharedCatalogue] currentSubjectDevice];
    p.conditiontype      = [[Catalogue sharedCatalogue] currentCondition];
    p.conditionarguments = [[Catalogue sharedCatalogue] conditionArguments];
    p.actionarguments    = [[Catalogue sharedCatalogue] actionArguments];
    p.actionsubject      = [[Catalogue sharedCatalogue] currentActionSubject];
    p.actiontype         = [[Catalogue sharedCatalogue] currentActionType];
}



@end
