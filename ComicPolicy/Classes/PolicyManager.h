//
//  PolicyManager.h
//  ComicPolicy
//
//  Created by Tom Lodge on 04/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PolicyManager : NSObject {
    NSString* currentPolicy;
    NSArray *policyids;
    NSDictionary *policies;
    NSMutableDictionary *conditionArguments;
}

+ (PolicyManager *)sharedPolicyManager;

-(void) loadPolicy:(NSString*) policyid;
-(void) setConditionArguments:(NSMutableDictionary *) args;
-(NSString *) generatePolicy;
-(void) loadFirstPolicy;

@property(nonatomic, retain) NSArray* policyids;
@property(nonatomic, retain) NSDictionary* policies;
@property(nonatomic, retain) NSString* currentPolicy;
@end
