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
        }
    }
    return self;
}


-(void) loadPolicy:(NSString*) policyid{
    NSDictionary *policy = [policies objectForKey:policyid];
    if (policy != nil){
        NSDictionary *subject = [policy objectForKey:@"subject"];
        NSDictionary *condition = [policy objectForKey:@"condition"];
        NSDictionary *action = [policy objectForKey:@"action"];
        NSArray *actionoptions = [action objectForKey:@"options"];
        
        [[Catalogue sharedCatalogue] setSubject:[subject objectForKey:@"owner"] device:[subject objectForKey:@"device"]];
        [[Catalogue sharedCatalogue] setCondition:[condition objectForKey:@"type"]];
        
        [[Catalogue sharedCatalogue] setAction:[action objectForKey:@"type"] subject:[actionoptions objectAtIndex:0] option:[actionoptions objectAtIndex:1]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"policyLoaded" object:nil userInfo:nil];
	
}


@end
