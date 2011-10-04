//
//  URLObject.m
//  ComicPolicy
//
//  Created by Tom Lodge on 04/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "URLObject.h"


@implementation URLObject

@synthesize proto;
@synthesize saddr;
@synthesize sport;
@synthesize daddr;
@synthesize dport;
@synthesize hst;
@synthesize uri;
@synthesize cnt;
@synthesize tstamp;


-(id) initWithUrl: (Url *) u{
    
    if (self = [super init])
	{
        self.proto = u->proto;
        self.saddr = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", inet_ntoa(u->saddr)]];
        self.sport = u->sport;
		self.daddr = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", inet_ntoa(u->daddr)]];
        self.dport = u->dport;
        self.hst   = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", u->hst]];
        self.uri   = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", u->uri]];
        self.cnt   = [[NSString alloc] initWithString: [NSString stringWithFormat:@"%s", u->cnt]];
		self.tstamp = u->tstamp;
    }

    return self;
}

@end
