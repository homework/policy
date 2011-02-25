//
//  SubjectImageLookup.m
//  ComicPolicy
//
//  Created by Tom Lodge on 25/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SubjectImageLookup.h"


@implementation SubjectImageLookup

static NSArray* topImages;
static NSArray* bottomImages;

static int  topImageIndex = 0;
static int bottomImageIndex = 0;
static SubjectImageLookup *sharedSingleton;

+(void) initialize{
	static BOOL initialized = NO;
	
	if (!initialized)
	{
		initialized = YES;
		
		topImageIndex = -1;
		bottomImageIndex = -1;
		
		topImages = [[NSArray arrayWithObjects:	@"dad.png",
						 @"mum.png",
						 @"katie.png",
						 @"john.png",
						 @"everyone.png",nil] retain];
		
		
		bottomImages = [[NSArray arrayWithObjects:	@"condcomputer.png",
						 @"condphone.png",
						 @"condlaptop.png",
						 @"conddesktop.png",
						 @"conddevices.png",nil] retain];
		
		
		sharedSingleton = [[SubjectImageLookup alloc] init];
	}
}

-(NSString *) getNextTopImage{
	return [topImages objectAtIndex:++topImageIndex % [topImages count]];
}

-(NSString *) getCurrentTopImage{
	return [topImages objectAtIndex:topImageIndex % [topImages count]];
}

-(NSString *) getNextBottomImage{
	return [bottomImages objectAtIndex:++bottomImageIndex % [bottomImages count]];
}

-(NSString *) getPreviousTopImage{
	return [topImages objectAtIndex:bottomImageIndex-- % [topImages count]];
}


-(NSString *) getPreviousBottomImage{
	return [bottomImages objectAtIndex:bottomImageIndex-- % [bottomImages count]];	
}
-(NSString *) getCurrentBottomImage{
	return [bottomImages objectAtIndex:bottomImageIndex % [bottomImages count]];	
}

@end
