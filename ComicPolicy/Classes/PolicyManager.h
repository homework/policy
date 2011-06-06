//
//  PolicyManager.h
//  ComicPolicy
//
//  Created by Tom Lodge on 04/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PolicyManager : NSObject {
    NSArray *policyids;
    NSDictionary *policies;
}

+ (PolicyManager *)sharedPolicyManager;
-(void) loadPolicy:(NSString*) policyid;
-(NSString *) generatePolicy;
-(void) loadFirstPolicy;

@property(nonatomic, retain) NSArray* policyids;
@property(nonatomic, retain) NSDictionary* policies;

@end
