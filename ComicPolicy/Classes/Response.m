//
//  PolicyResponse.m
//  ComicPolicy
//
//  Created by Tom Lodge on 22/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Response.h"


@implementation Response

@synthesize pid;
@synthesize requestid;
@synthesize success;
@synthesize message;
@synthesize tstamp;

-(id) initWithPolicyResponse: (PolicyResponse *) p{
	if (self = [super init])
	{
        self.requestid = p->requestid;
        self.pid = p->pid;
        self.success = p->success;
		self.message   = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", p->message]];
		self.tstamp = p->tstamp;
    }
	
    return self;
}


@end
