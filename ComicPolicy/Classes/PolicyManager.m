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

@implementation PolicyManager

@synthesize policyids;
@synthesize policies;
@synthesize currentPolicy;

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
            self.policies = [data objectForKey:@"policies"];
            self.policyids = [policies allKeys];
            conditionArguments = [[[NSMutableDictionary alloc] init] retain];
            self.currentPolicy = @"1";
        }
    }
    return self;
}


-(void) loadFirstPolicy{
    if (self.policyids != nil){
        [self loadPolicy:[policyids objectAtIndex:0]];
    }
}

-(void) loadPolicy:(NSString*) policyid{
    
    NSDictionary *policy = [policies objectForKey:policyid];
    
    if (policy != nil){
        self.currentPolicy = policyid;
        NSDictionary *subject = [policy objectForKey:@"subject"];
        NSDictionary *condition = [policy objectForKey:@"condition"];
        NSDictionary *action = [policy objectForKey:@"action"];
        NSArray *actionarguments = [action objectForKey:@"arguments"];
        
        //some data validation required here...
        
        [[Catalogue sharedCatalogue] setSubject:[subject objectForKey:@"owner"] device:[subject objectForKey:@"device"]];
        
        [[Catalogue sharedCatalogue] setCondition:[condition objectForKey:@"type"]];
        
        [self setConditionArguments:[condition objectForKey:@"arguments"]];
       
        NSString *asubject = [actionarguments objectAtIndex:0];
        NSString *atype =    [action objectForKey:@"type"];
        [[Catalogue sharedCatalogue] setAction:atype subject:asubject option:[actionarguments objectAtIndex:1]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"policyLoaded" object:nil userInfo:nil];
    
	
}

-(void) setConditionArguments:(NSMutableDictionary *)args{
    [conditionArguments setObject:args forKey:currentPolicy];
}

-(NSMutableDictionary *) getConditionArguments{
    return [conditionArguments objectForKey:currentPolicy];
}

-(NSString *)generatePolicy{
    NSMutableDictionary *policy = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *action = [[NSMutableDictionary alloc] init];
    
    [policy setObject: [[Catalogue sharedCatalogue] currentSubjectDevice] forKey:@"subject"];
    [condition setObject: [[Catalogue sharedCatalogue] currentCondition] forKey:@"type"];
    [condition setObject: [self getConditionArguments] forKey:@"arguments"];
    [action setObject: [[Catalogue sharedCatalogue] currentActionType] forKey:@"action"];
    [action setObject: [[Catalogue sharedCatalogue] currentActionSubject] forKey:@"subject"];
    [action setObject: [[Catalogue sharedCatalogue] currentAction] forKey:@"arguments"];
    
    [policy setObject:condition forKey:@"condition"];
    [policy setObject:action forKey:@"action"];
    
    SBJsonWriter* writer = [SBJsonWriter new];
    NSString *myjson = [writer stringWithObject:policy];
    return myjson;
}


@end
