//
//  PolicyStateObject.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PolicyStateObject.h"


@implementation PolicyStateObject

@synthesize pid;
@synthesize state;
@synthesize pondertalk;
@synthesize tstamp;

-(id) initWithPolicyState: (PolicyState *) ps{
    if (self = [super init])
	{
      
        self.pid        = ps->pid;
		self.state      = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", ps->state]];
        self.pondertalk = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", ps->pondertalk]];
		self.tstamp     = ps->tstamp;
    }
	
    return self;
    
}

@end
