//
//  BlockImageLookup.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockActionImageLookup.h"


@implementation BlockActionImageLookup


static int personImageIndex	= 0;
static int deviceImageIndex		= 0;
static BlockActionImageLookup *sharedSingleton;
static NSArray* blockPersonImages;
static NSArray* blockDeviceImages;


+(void) initialize{
	static BOOL initialized = NO;
	
	if (!initialized)
	{
		initialized = YES;
		personImageIndex = -1;
		deviceImageIndex = -1;
		
		blockPersonImages = [[NSArray arrayWithObjects: @"blockdad.png",
							   @"blockmum.png",
							   @"blockjohn.png",
							   @"blockkatie.png",nil] retain];
		
		blockDeviceImages = [[NSArray arrayWithObjects:@"ascomputer.png",
						   @"aslaptop.png",
						   @"asphone.png",
						   @"asdesktop.png",
						   nil] retain];
		
		
		sharedSingleton = [[BlockActionImageLookup alloc] init];
	}
}



-(NSString *) getNextTopImage{
	return [blockPersonImages objectAtIndex:++personImageIndex % [blockPersonImages count]];
}

-(NSString *) getNextBottomImage{
	return [blockDeviceImages objectAtIndex:++deviceImageIndex % [blockDeviceImages count]];
}

-(NSString *) getPreviousTopImage{
	return [blockPersonImages objectAtIndex:--personImageIndex % [blockPersonImages count]];
}

-(NSString *) getPreviousBottomImage{
	return [blockDeviceImages objectAtIndex:--deviceImageIndex % [blockDeviceImages count]];
}

-(NSString *) getCurrentTopImage{
	return [blockPersonImages objectAtIndex:personImageIndex % [blockPersonImages count]];	
}

-(NSString *) getCurrentBottomImage{
	return [blockDeviceImages objectAtIndex:deviceImageIndex % [blockDeviceImages count]];	
}


@end
