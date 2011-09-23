//
//  PolicyStateObject.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "timestamp.h"


@interface PolicyStateObject : NSObject {
    unsigned int pid;
    NSString* state;
    NSString* pondertalk;
    tstamp_t tstamp;
}

typedef struct policy_state{
    unsigned int pid;
    char state[9];
    char pondertalk[1025];
    tstamp_t tstamp;
}PolicyState;


@property(nonatomic, assign) unsigned int pid;
@property(nonatomic, copy) NSString *state;
@property(nonatomic, copy) NSString *pondertalk;
@property(nonatomic, assign) tstamp_t tstamp;

-(id) initWithPolicyState: (PolicyState *) ps;

@end
