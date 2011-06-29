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

@interface PolicyManager()
-(void) readInPolicies:(NSMutableDictionary *) policydict;
-(void) sendPolicy:(NSString*)json;
-(void) newDefaultPolicy;
-(void) saveCurrentPolicy;


-(NSMutableDictionary*) convertToTypedHashtable:(NSMutableDictionary*)dict;
-(NSDictionary *) convertToTypedArray:(NSArray *) array;

@end

@implementation PolicyManager

@synthesize policyids;
@synthesize policies;
@synthesize currentPolicy;
@synthesize defaultPolicy;

static int localId;

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
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"policies" ofType:@"json"];
        NSString *content = [[NSString alloc] initWithContentsOfFile:filePath];
        SBJsonParser *jsonParser = [SBJsonParser new];
        
        NSDictionary *data  = (NSDictionary *) [jsonParser objectWithString:content error:nil];
        
        
        if (data == nil){
            NSLog(@"policy data is malformed");
        }
        else{
            localId = 1;
            localLookup    = [[[NSMutableDictionary alloc] init] retain];
            self.policies       = [[NSMutableDictionary alloc] init];
                               
            [self readInPolicies:[data objectForKey:@"policies"]];
            
            self.defaultPolicy = [[Policy alloc] initWithDictionary:[data objectForKey:@"default"]];
            
            self.policyids = [[NSMutableArray alloc] initWithArray: [policies allKeys]];
            
            //conditionArguments = [[[NSMutableDictionary alloc] init] retain];
            
            [self loadFirstPolicy];
        }
    }
    return self;
}

-(void) readInPolicies:(NSMutableDictionary *)policydict{
    
    for (NSString *identity in [policydict allKeys]){
            
        Policy *apolicy = [[Policy alloc] initWithDictionary:[policydict objectForKey:identity]];
        
        [apolicy setIdentity:identity];
        
        [self.policies setValue:apolicy forKey:[NSString stringWithFormat:@"%d", localId]];
        
        [localLookup setValue:[NSString stringWithFormat:@"%d", localId] forKey:identity];
        
        [apolicy release];
        
        localId++;
    }
}

-(void) loadFirstPolicy{
    if (self.policyids != nil){
        [self loadPolicy:[policyids objectAtIndex:0]];
    }
}


-(NSMutableDictionary *) getConditionArguments:(NSString*)type{
    NSLog(@"chceking args for policy type %@", type);
    if ([currentPolicy.conditiontype isEqualToString:type]){
        return currentPolicy.conditionarguments;
    }
    return nil;
}


-(void) newDefaultPolicy{
    
    Policy *apolicy  = [[Policy alloc] initWithPolicy:defaultPolicy];

    NSString* policyid = [NSString stringWithFormat:@"%d",localId++];
    
    [policies setObject:apolicy forKey:policyid];
    [policyids addObject:policyid];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"totalPoliciesChanged" object:nil userInfo:nil];
}

-(void) loadPolicy:(NSString*) localpolicyid{

    Policy *apolicy = [policies objectForKey:localpolicyid];
    
    if (apolicy != nil){
        self.currentPolicy = apolicy;
        [[Catalogue sharedCatalogue] setSubject:apolicy.subjectowner device:apolicy.subjectdevice];
        [[Catalogue sharedCatalogue] setCondition:apolicy.conditiontype options:apolicy.conditionarguments];
        //should take an array of arguments for 'option'
        [[Catalogue sharedCatalogue] setAction:apolicy.actiontype subject:apolicy.actionsubject options:apolicy.actionarguments];
        
        
      
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"policyLoaded" object:nil userInfo:nil];
}



/*
 * Take the current representation of the policy, and send it to the policyManager backend to install
 * This method is triggered from the UI.  Data needs a bit of massaging to get in a form to allow it to
 * be marhalled at the server.
 */

-(NSString *)savePolicy{
    
      
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *action = [[NSMutableDictionary alloc] init];
    
    [condition setObject: [[Catalogue sharedCatalogue] currentCondition] forKey:@"type"];
    
    [condition setObject: [self convertToTypedHashtable:[[Catalogue sharedCatalogue] conditionArguments]] forKey:@"arguments"];
    
    [action setObject: [[Catalogue sharedCatalogue] currentActionType] forKey:@"type"];
    [action setObject: [[Catalogue sharedCatalogue] currentActionSubject] forKey:@"subject"];
    NSArray* actionArgs = [[NSArray alloc] initWithObjects:[[Catalogue sharedCatalogue] currentAction], nil];
    [action setObject: [self convertToTypedArray:actionArgs] forKey:@"arguments"];

    SBJsonWriter* writer = [SBJsonWriter new];
    writer.sortKeys = YES;
    /*
     * To control the ordering of the json elements we need to parse each section independently
     * rather than as a single dictionary.
     */
  
    NSString *constring = [writer stringWithObject:condition];
    NSString *actstring = [writer stringWithObject:action];
    NSString * myjson;
    
    if ( currentPolicy.identity != NULL){
        myjson = [NSString stringWithFormat:@"{\"policy\":{\"identity\":\"%@\",\"subject\":\"%@\",\"condition\":%@,\"action\":%@}}",  currentPolicy.identity, [[Catalogue sharedCatalogue] currentSubjectDevice] ,constring, actstring];
    }else{
        myjson = [NSString stringWithFormat:@"{\"policy\":{\"subject\":\"%@\",\"condition\":%@,\"action\":%@}}", [[Catalogue sharedCatalogue] currentSubjectDevice] ,constring, actstring];
    }
    
    [self sendPolicy: myjson];
    
    return myjson;
}

-(NSDictionary *) convertToTypedArray:(NSArray *) array{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:array forKey:@"string"];
    return dict;
}

-(NSMutableDictionary *) convertToTypedHashtable:(NSMutableDictionary*)dict{
    
    NSMutableDictionary* hashtable = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    NSLog(@"condition args dict is %@",dict);
    
    for (NSString* key in [dict allKeys]){
        NSObject *value = [dict objectForKey:key];
        
        if ([value isKindOfClass:[NSArray class]]){
             NSLog(@"entry is an array...");
            NSMutableDictionary *arraydict = [[NSMutableDictionary alloc] init];
            [arraydict setObject:value forKey:@"string"]; 
            
            NSMutableDictionary *entrydict = [[NSMutableDictionary alloc] init];
            [entrydict setObject: key forKey:@"string"];
            [entrydict setObject: arraydict forKey:@"string-array"]; 
            [entries addObject:entrydict];
        }
        //if ([value isKindOfClass:[NSString class]]){
        else{
            NSLog(@"entry is a string... %@ %@ ", key, [dict objectForKey:key]);
            NSArray* entry = [[NSArray alloc] initWithObjects:key, [dict objectForKey:key], nil];
            NSMutableDictionary *entrydict = [[NSMutableDictionary alloc] init];
            [entrydict setObject:entry forKey:@"string"];
            [entries addObject:entrydict];
        }
    }
    [hashtable setObject:entries forKey:@"entry"];
    return hashtable;
}


-(void) sendPolicy:(NSString*) json{
    NSString *rootURL  = [[NetworkManager sharedManager] rootURL];
    NSString *strurl = [NSString stringWithFormat:@"%@/policy/save", rootURL];
    NSLog(@"connecting to %@", strurl);
    NSURL *url = [NSURL URLWithString:strurl];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:json forKey:@"policy"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(addedRequestComplete:)];
    [request setDidFailSelector:@selector(delegateFailed:)];
    [[NetworkManager sharedManager] addRequest:request]; 
}

- (void)addedRequestComplete:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary *data  = (NSDictionary *) [jsonParser objectWithString:responseString error:nil];
    NSLog(@"got response %@ %@ %@", responseString, [data objectForKey:@"result"], [data objectForKey:@"message"]); 
    
    if ([[data objectForKey:@"result"] isEqualToString:@"success"]){
        currentPolicy.identity = [data objectForKey:@"message"];
        [self saveCurrentPolicy];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestComplete" object:nil userInfo:nil];
}

- (void)delegateFailed:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestComplete" object:nil userInfo:nil];
}

-(void) saveCurrentPolicy{
    currentPolicy.subjectdevice = [[Catalogue sharedCatalogue] currentSubjectDevice];
    currentPolicy.subjectowner =  [[Catalogue sharedCatalogue] currentSubjectOwner];
    
    currentPolicy.conditiontype      = [[Catalogue sharedCatalogue] currentCondition];
    currentPolicy.conditionarguments = [[Catalogue sharedCatalogue] conditionArguments];
    
    currentPolicy.actionarguments   = [[NSArray alloc] initWithObjects:[[Catalogue sharedCatalogue] currentAction], nil];
    currentPolicy.actionsubject     = [[Catalogue sharedCatalogue] currentActionSubject];
    currentPolicy.actiontype        = [[Catalogue sharedCatalogue] currentActionType];
}




@end
