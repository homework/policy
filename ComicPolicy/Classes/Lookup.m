//
//  Lookup.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Lookup.h"

@interface Lookup (PrivateMethods)
	+(void) createSceneMonitorTable;
	+(void) createSceneResultTable;
@end

@implementation Lookup

static BOOL init = FALSE;
static NSArray *conditions;
static NSArray *monitors;
static NSArray *actions;
static NSArray *results;




NSMutableDictionary *scenemonitor;
NSMutableDictionary *sceneresult;


+(void) initialize{
	if (init)
		return;

	conditionImages = [[NSArray arrayWithObjects:@"surfing.png",
												 @"downloading.png",
												 @"gaming.png",
												 @"streaming.png",
												 @"timed.png", 
												 @"bandwidth.png",
												 @"visiting.png",nil] retain];
	
	conditions = [[NSArray arrayWithObjects: @"bandwidth.png",
				   @"downloading.png",
				   @"gaming.png",
				   @"streaming.png",
				   @"surfing.png",	
				   @"timed.png",
				   @"visiting.png",
				   nil] retain];
	
	actions		=[[NSArray arrayWithObjects: @"notifydad.png",
				   @"notifyeveryone.png",
				   @"notifyjohn.png",
				   @"notifykatie.png",
				   @"notifymum.png",
				   nil] retain];
	
	results		= [[NSArray arrayWithObjects: @"dadwaiting.png",
					@"katiewaiting.png",
					@"johnwaiting.png",
					@"katiewaiting.png",
					@"mumwaiting.png",
					nil] retain];
	
	monitors	= [[NSArray arrayWithObjects: @"resultbandwidth.png",
					@"resulttype.png",
					@"resulttype.png",
					@"resulttype.png",
					@"resulttype.png",
					@"resulttime.png",
					@"resultvisits.png",
					nil] retain];
	
	[self createSceneMonitorTable];
	[self createSceneResultTable];
	init = TRUE;
}

+(void) createSceneMonitorTable{
	
	scenemonitor = [[NSMutableDictionary dictionaryWithCapacity:10] retain];

	for (int i = 0; i < MIN([conditions count], [monitors count]); i++){
		[scenemonitor setObject:[monitors objectAtIndex:i] forKey:[conditions objectAtIndex:i]];
	}
	
}

					  
+(NSString *) nextConditionImage{
	return [conditionImages objectAtIndex:++conditionImageIndex % [conditionImages count]];
}

+(void) createSceneResultTable{
	sceneresult = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	
	for (int i = 0; i < MIN([actions count], [results count]); i++){
		[sceneresult setObject:[results objectAtIndex:i] forKey:[actions objectAtIndex:i]];
	}
}

+(NSString *) lookupmonitor: (NSString *) conditionscene{
	return [scenemonitor objectForKey:conditionscene];
}

+(NSString *) lookupresult: (NSString *) actionscene{
	return [sceneresult objectForKey:actionscene];
}


@end
