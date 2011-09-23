//
//  FiredEvent.m
//  ComicPolicy
//
//  Created by Tom Lodge on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FiredEvent.h"


@implementation FiredEvent

@synthesize  pid;
@synthesize event;
@synthesize tstamp;

-(id) initWithPolicyFiredEvent: (PolicyFired *) pe{
	if (self = [super init])
	{
        self.pid = pe->pid;
		self.event   = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", pe->event]];
		self.tstamp = pe->tstamp;
    }
	
    return self;
}
@end
