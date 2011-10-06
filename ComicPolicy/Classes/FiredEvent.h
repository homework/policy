//
//  FiredEvent.h
//  ComicPolicy
//
//  Created by Tom Lodge on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "timestamp.h"

@interface FiredEvent : NSObject {
    int pid;
    NSString* state;
    NSString* event;
    tstamp_t tstamp;
}

typedef struct policy_fired{
    unsigned int pid;
    char state[10];
    char event[513];
    tstamp_t tstamp;
}PolicyFired;


@property(nonatomic, assign) int pid;
@property(nonatomic, copy) NSString* state;
@property(nonatomic, copy) NSString* event;
@property(nonatomic, assign) tstamp_t tstamp;

-(id) initWithPolicyFiredEvent: (PolicyFired *) pe;

@end
