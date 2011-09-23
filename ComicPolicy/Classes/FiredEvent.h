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
    NSString* event;
    tstamp_t tstamp;
}

typedef struct policy_fired{
    unsigned int pid;
    char event[512];
    tstamp_t tstamp;
}PolicyFired;


@property(nonatomic, assign) int pid;
@property(nonatomic, retain) NSString* event;
@property(nonatomic, assign) tstamp_t tstamp;

-(id) initWithPolicyFiredEvent: (PolicyFired *) pe;

@end
