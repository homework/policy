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
    
    NSArray *policyids;               //the list of policyids
    
    NSDictionary *policies;           //the dictionary containing all known policies
    
    NSMutableDictionary *localLookup;  //mapping between the system allocated policy id and the locally generated one.
    
}

+ (PolicyManager *)sharedPolicyManager;

-(void) loadPolicy:(NSString*) policyid;
-(NSString *) savePolicy;
-(void) loadFirstPolicy;

@property(nonatomic, retain) NSArray* policyids;
@property(nonatomic, retain) NSDictionary* policies;
@property(nonatomic, retain) Policy* currentPolicy;

-(NSMutableDictionary *) getConditionArguments:(NSString*) localpolicyid;

@end
