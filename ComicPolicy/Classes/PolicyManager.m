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
#import "PolicyTranslator.h"

@interface PolicyManager()
-(void) readInPolicies:(NSMutableDictionary *) policydict;
-(void) sendPolicy:(NSString*)json;
-(NSMutableDictionary*) convertToHashtable:(NSMutableDictionary*)dict;
@end

@implementation PolicyManager

@synthesize policyids;
@synthesize policies;
@synthesize currentPolicy;

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
            
            //self.policies = [data objectForKey:@"policies"];
            
            self.policyids = [policies allKeys];
            
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


-(void) loadPolicy:(NSString*) localpolicyid{

    Policy *apolicy = [policies objectForKey:localpolicyid];
    
    if (apolicy != nil){
        NSLog(@"loading in a new policy.. %@", localpolicyid);
        self.currentPolicy = apolicy;
          NSLog(@"policy type is %@", self.currentPolicy.conditiontype);
        [[Catalogue sharedCatalogue] setSubject:apolicy.subjectowner device:apolicy.subjectdevice];
        [[Catalogue sharedCatalogue] setCondition:apolicy.conditiontype options:apolicy.conditionarguments];
        //should take an array of arguments for 'option'
        [[Catalogue sharedCatalogue] setAction:apolicy.actiontype subject:apolicy.actionsubject options:apolicy.actionarguments];
        
        
      
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"policyLoaded" object:nil userInfo:nil];
}

/*
-(void) loadPolicy:(NSString*) policyid{
    
    NSDictionary *policy = [policies objectForKey:policyid];
    
    if (policy != nil){
       
        NSDictionary *subject = [policy objectForKey:@"subject"];
       
        NSDictionary *condition = [policy objectForKey:@"condition"];
        
        NSDictionary *action = [policy objectForKey:@"action"];
        
        NSArray *actionarguments = [action objectForKey:@"arguments"];
        
      
        //some data validation required here...
        
        [[Catalogue sharedCatalogue] setSubject:[subject objectForKey:@"owner"] device:[subject objectForKey:@"device"]];
        [[Catalogue sharedCatalogue] setCondition:[condition objectForKey:@"type"]];
        
        //[self setConditionArguments:[condition objectForKey:@"arguments"]];
        NSString *asubject = [actionarguments objectAtIndex:0];
        NSString *atype =    [action objectForKey:@"type"];
        [[Catalogue sharedCatalogue] setAction:atype subject:asubject option:[actionarguments objectAtIndex:1]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"policyLoaded" object:nil userInfo:nil];
}
*/

/*
 * Take the current representation of the policy, and send it to the policyManager backend to install
 * This method is triggered from the UI.  Data needs a bit of massaging to get in a form to allow it to
 * be marhalled at the server.
 */

-(NSString *)savePolicy{
    
      
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *action = [[NSMutableDictionary alloc] init];
    
    [condition setObject: [[Catalogue sharedCatalogue] currentCondition] forKey:@"type"];
    [condition setObject: [self convertToHashtable:[[Catalogue sharedCatalogue] conditionArguments]] forKey:@"arguments"];
    
    [action setObject: [[Catalogue sharedCatalogue] currentActionType] forKey:@"action"];
    [action setObject: [[Catalogue sharedCatalogue] currentActionSubject] forKey:@"actionsubject"];
    NSArray* actionArgs = [[NSArray alloc] initWithObjects:[[Catalogue sharedCatalogue] currentAction], nil];
    [action setObject: actionArgs forKey:@"arguments"];

    SBJsonWriter* writer = [SBJsonWriter new];
    
    /*
     * To control the ordering of the json elements we need to parse each section independently
     * rather than as a single dictionary.
     */
  
    NSString *constring = [writer stringWithObject:condition];
    NSString *actstring = [writer stringWithObject:action];
    
    NSString* myjson = [NSString stringWithFormat:@"{\"policy\":{\"identity\":\"%@\",\"subject\":\"%@\",\"condition\":%@},\"action\":%@}",  currentPolicy.identity, [[Catalogue sharedCatalogue] currentSubjectDevice] ,constring, actstring];
    
    [self sendPolicy: myjson];
    
    return myjson;
}

-(NSMutableDictionary *) convertToHashtable:(NSMutableDictionary*)dict{
    NSMutableDictionary* hashtable = [[NSMutableDictionary alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (NSString* key in [dict allKeys]){
        NSArray* entry = [[NSArray alloc] initWithObjects:key, [dict objectForKey:key], nil];
        NSMutableDictionary *entrydict = [[NSMutableDictionary alloc] init];
        [entrydict setObject:entry forKey:@"string"];
        [entries addObject:entrydict];
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
    [[NetworkManager sharedManager] addRequest:request]; 
}

- (void)addedRequestComplete:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
    NSLog(@"got response %@", responseString); 
}



@end
