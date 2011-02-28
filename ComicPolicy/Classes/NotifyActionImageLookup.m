//
//  ActionImageLookup.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotifyActionImageLookup.h"


@implementation NotifyActionImageLookup

static int personImageIndex	= 0;
static int byImageIndex		= 0;
static NotifyActionImageLookup *sharedSingleton;
static NSArray* notifyPersonImages;
static NSArray* notifyByImages;


+(void) initialize{
	static BOOL initialized = NO;
	
	if (!initialized)
	{
		initialized = YES;
		personImageIndex = -1;
		byImageIndex = -1;
		
		notifyPersonImages = [[NSArray arrayWithObjects: @"notifydad.png",
							   @"notifymum.png",
							   @"notifyjohn.png",
							   @"notifykatie.png",nil] retain];
		
		notifyByImages = [[NSArray arrayWithObjects:@"notifybymail.png",
						   @"notifybysound.png",
						   @"notifybytweet.png",
						   @"notifybyphone.png",
						   nil] retain];
		
			
		sharedSingleton = [[NotifyActionImageLookup alloc] init];
	}
}



-(NSString *) getNextTopImage{
	return [notifyPersonImages objectAtIndex:++personImageIndex % [notifyPersonImages count]];
}

-(NSString *) getNextBottomImage{
	return [notifyByImages objectAtIndex:++byImageIndex % [notifyByImages count]];
}

-(NSString *) getPreviousTopImage{
	return [notifyPersonImages objectAtIndex:--personImageIndex % [notifyPersonImages count]];
}

-(NSString *) getPreviousBottomImage{
	return [notifyByImages objectAtIndex:--byImageIndex % [notifyByImages count]];
}

-(NSString *) getCurrentTopImage{
	return [notifyPersonImages objectAtIndex:personImageIndex % [notifyPersonImages count]];	
}

-(NSString *) getCurrentBottomImage{
	return [notifyByImages objectAtIndex:byImageIndex % [notifyByImages count]];	
}

@end
