//
//  RequestObject.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestObject.h"


@implementation RequestObject

@synthesize  localId;
@synthesize requestType;
@synthesize  requestString;

-(id) initWithValues:(NSString *) lid type: (RequestType) type request: (NSString *) request{
    
    if (self = [super init])
	{
        self.localId = lid;
        self.requestType = type;
        self.requestString = request;
    }
	
    return self;
}

@end
