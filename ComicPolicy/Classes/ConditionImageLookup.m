//
//  ConditionImageLookup.m
//  ComicPolicy
//
//  Created by Tom Lodge on 25/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionImageLookup.h"


@implementation ConditionImageLookup


static ConditionImageLookup *sharedSingleton;
static NSArray* conditionImages;
static int conditionIndex;

+(void) initialize{
	static BOOL initialized = NO;
	
	if (!initialized)
	{
		initialized = YES;
		conditionIndex = -1;
		
		conditionImages = [[NSArray arrayWithObjects:@"surfing.png",
							@"downloading.png",
							@"gaming.png",
							@"streaming.png",
							@"timed.png", 
							@"bandwidth.png",
							@"visiting.png",nil] retain];
		
		sharedSingleton = [[ConditionImageLookup alloc] init];
	}
}

-(NSString *) getNextTopImage{
	return [conditionImages objectAtIndex:++conditionIndex % [conditionImages count]];
}

-(NSString *) getNextBottomImage{
	return [conditionImages objectAtIndex:++conditionIndex % [conditionImages count]];
}

-(NSString *) getPreviousTopImage{
	return [conditionImages objectAtIndex:conditionIndex-- % [conditionImages count]];
}

-(NSString *) getPreviousBottomImage{
	return [conditionImages objectAtIndex:conditionIndex-- % [conditionImages count]];	
}

-(NSString *) getCurrentTopImage{
	return [conditionImages objectAtIndex:conditionIndex % [conditionImages count]];	
}

-(NSString *) getCurrentBottomImage{
	return [conditionImages objectAtIndex:conditionIndex % [conditionImages count]];	
}
@end
