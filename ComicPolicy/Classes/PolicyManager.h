//
//  PolicyManager.h
//  ComicPolicy
//
//  Created by Tom Lodge on 04/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Policy;
@class Response;
@class FiredEvent;
@class PolicyStateObject;
@class RequestObject;

@interface PolicyManager : NSObject {
    
    Policy* currentPolicy;
    
    Policy *defaultPolicy;
    
    NSMutableArray *policyids;                 //the list of policyids
    
    NSMutableDictionary *policies;     //the dictionary containing all known policies
    
    NSMutableDictionary *localLookup;  //mapping between the system allocated policy id and the locally generated one.
   
    NSMutableDictionary *requesttable;
}

+ (PolicyManager *)sharedPolicyManager;

-(void) loadPolicy:(NSString*) policyid;
-(NSString *) createPonderTalk; 
-(void) loadFirstPolicy;
-(void) refresh;
-(void) reset;
-(void) deleteAll;
-(void) deleteCurrentPolicy;
-(void) newDefaultPolicy;
-(void) policyFired:(FiredEvent *) fe;
-(void) handlePolicyResponse:(Response *) response;
-(void) setUpWithPolicies:(NSMutableArray *) policystateobjects;

-(BOOL) hasFiredForSubject:(NSString *)subject;
-(BOOL) hasFired;
-(BOOL) isInSync;

@property(nonatomic, retain) NSMutableArray* policyids;
@property(nonatomic, retain) NSMutableDictionary* policies;
@property(nonatomic, retain) Policy* currentPolicy;
@property(nonatomic, retain) Policy* defaultPolicy;

-(NSMutableDictionary *) getConditionArguments:(NSString*) localpolicyid;
-(void) savePolicyToHWDB;
-(void) enablePolicy;
@end
