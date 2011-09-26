//
//  PolicyResponse.h
//  ComicPolicy
//
//  Created by Tom Lodge on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "timestamp.h"

@interface Response : NSObject {
    int requestid;
    int pid;
    bool success;
    NSString* message;
    tstamp_t tstamp;
}

typedef struct policy_response{
    unsigned int requestid;
    unsigned int pid;
    bool success;
    char message[1025];
    tstamp_t tstamp;
}PolicyResponse;

@property(nonatomic, retain) NSString *message;
@property(nonatomic, assign) int requestid;
@property(nonatomic, assign) int pid;
@property(nonatomic, assign) bool success;
@property(nonatomic, assign) tstamp_t tstamp;

-(id) initWithPolicyResponse: (PolicyResponse *) p;


@end
