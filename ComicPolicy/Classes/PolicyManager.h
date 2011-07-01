//
//  PolicyManager.h
//  ComicPolicy
//
//  Created by Tom Lodge on 04/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Policy;

@interface PolicyManager : NSObject {
    
    Policy* currentPolicy;
    
    Policy *defaultPolicy;
    
    NSMutableArray *policyids;                 //the list of policyids
    
    NSMutableDictionary *policies;     //the dictionary containing all known policies
    
    NSMutableDictionary *localLookup;  //mapping between the system allocated policy id and the locally generated one.
    
}

+ (PolicyManager *)sharedPolicyManager;

-(void) loadPolicy:(NSString*) policyid;
-(NSString *) savePolicy;
-(void) loadFirstPolicy;
-(void) newDefaultPolicy;
-(void) policyFired:(NSString *) policyid;
-(NSString*) currentPolicyId;

-(BOOL) hasFiredForSubject:(NSString *)subject;
-(BOOL) hasFired;

@property(nonatomic, retain) NSMutableArray* policyids;
@property(nonatomic, retain) NSMutableDictionary* policies;
@property(nonatomic, retain) Policy* currentPolicy;
@property(nonatomic, retain) Policy* defaultPolicy;

-(NSMutableDictionary *) getConditionArguments:(NSString*) localpolicyid;

@end
