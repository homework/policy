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
static NSArray *monitorvcs;
static NSArray *actions;
static NSArray *results;

static NSArray *notifyPersonImages;
static NSArray *notifyByImages;

static int notifyPersonImageIndex;
static int notifyByImageIndex;

NSMutableDictionary *scenemonitor;
NSMutableDictionary *sceneresult;
NSMutableDictionary *monitorvcresult;

+(void) initialize{
	if (init)
		return;

	
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
				   @"ascomputer.png",
				   @"asdesktop.png",
				   @"aslaptop.png",
				   @"asphone.png",
				   nil] retain];
	
	results		= [[NSArray arrayWithObjects: @"dadwaiting.png",
					@"katiewaiting.png",
					@"johnwaiting.png",
					@"katiewaiting.png",
					@"mumwaiting.png",
					@"computerunblocked.png",
					@"desktopunblocked.png",
					@"laptopunblocked.png",
					@"phoneunblocked.png",
					nil] retain];
	
	monitors	= [[NSArray arrayWithObjects: @"resultbandwidth.png",
					@"resulttype.png",
					@"resulttype.png",
					@"resulttype.png",
					@"resulttype.png",
					@"resulttime.png",
					@"resultvisits.png",
					nil] retain];
	
	monitorvcs = [[NSArray arrayWithObjects: @"ResultBandwidthViewController",
				   @"ResultTypeViewController",
				   @"ResultTypeViewController",
				   @"ResultTypeViewController",
				   @"ResultTypeViewController",
				   @"ResultTimeViewController",
				   @"ResultVisitsViewController",
				   nil] retain];
	
	/*monitors	= [[NSArray arrayWithObjects: @"http://192.168.1.1:8080/bandwidth-monitor/",
					@"http://news.bbc.co.uk",
					@"http://www.google.com",
					@"http://www.yahoo.com",
					@"http://192.168.1.1:8080/bandwidth-monitor/",
					@"http://www.drupal.org",
					@"http://192.168.1.1:8080",
					nil] retain];*/
	
	[self createSceneMonitorTable];
	[self createSceneResultTable];
	init = TRUE;
}

+(void) createSceneMonitorTable{
	
	scenemonitor = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	monitorvcresult= [[NSMutableDictionary dictionaryWithCapacity:10] retain];

	for (int i = 0; i < MIN([conditions count], [monitors count]); i++){
		[scenemonitor setObject:[monitors objectAtIndex:i] forKey:[conditions objectAtIndex:i]];
		[monitorvcresult setObject:[monitorvcs objectAtIndex:i] forKey:[conditions objectAtIndex:i]];
	}
	
}


+(NSString *) nextNotifyPersonImage{
	return [notifyPersonImages objectAtIndex:++notifyPersonImageIndex % [notifyPersonImages count]];
}

+(NSString *) nextNotifyByImage{
	return [notifyByImages objectAtIndex:++notifyByImageIndex % [notifyByImages count]];
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

+(NSString *) lookupmonitorvc: (NSString *) conditionscene{
	return [monitorvcresult objectForKey:conditionscene];
}

+(NSString *) lookupresult: (NSString *) actionscene{
	return [sceneresult objectForKey:actionscene];
}


@end
