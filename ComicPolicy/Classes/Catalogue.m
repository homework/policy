//
//  Catalogue.m
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Catalogue.h"



@implementation Catalogue

static BOOL init = FALSE;
static NSDictionary* imageLookup;
static NSDictionary* ownerLookup;

static NSArray* ownership;
static int ownershipindex;

static NSArray* devices;
static int devicesindex;

static NSDictionary* actionvcs;
static NSArray* actionvcsarray;
static int actionvcsindex;


static NSDictionary* actionLookup;
static NSArray* actionsubjectarray;
static int actionsubjectarrayindex;

static NSArray* actionarray;
static int actionarrayindex;
static NSArray* actiondevices;
static int actiondevicesindex;

static NSString* currentActionType;

+(void) initialize{
	
	if (init)
		return;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
	NSString *content = [[NSString alloc] initWithContentsOfFile:filePath];
	SBJsonParser *jsonParser = [SBJsonParser new];
	
	
	NSDictionary *data  = (NSDictionary *) [jsonParser objectWithString:content error:nil];
	
	if (data == nil){
		NSLog(@"DATA IS NIL>>>>");
	}
	else{
		NSDictionary *main = (NSDictionary *) [data objectForKey:@"catalogue"];
		imageLookup = [(NSDictionary *) [main objectForKey:@"images"] retain];
		ownerLookup = [(NSDictionary *) [main objectForKey:@"ownership"] retain];
		actionLookup = [(NSDictionary *) [main objectForKey:@"actions"] retain];
		
		
		NSDictionary *vcs = (NSDictionary *) [main objectForKey:@"vcs"];
		actionvcs = (NSDictionary *) [[vcs objectForKey:@"actions"] retain];

		for (NSString *key in vcs){
			NSLog(@"vcs...%@", key);
			
		}
		
		[self initActions];
		
		ownership = [[ownerLookup allKeys] retain];
		ownershipindex = 0;
		
		devices =  [[ownerLookup objectForKey:[self currentSubjectOwner]] retain];
		devicesindex = 0;
		
		
	}
	
	init = TRUE;
}	


+(void) updateActionSelections:(NSString *)subject{
	
	if ([currentActionType isEqualToString:@"block"]){
		if (actiondevices != NULL)
			[actiondevices release];
		
		actiondevices =  [[ownerLookup objectForKey:subject] retain];
		actiondevicesindex = 0;
	}
}

+(void) initActions{
	
	actionvcsarray = (NSArray *) [[actionvcs allKeys] retain];
	actionvcsindex = 0;
	currentActionType = [actionvcsarray objectAtIndex:actionvcsindex];
	
	NSDictionary *tmp = [actionLookup objectForKey:currentActionType];
	
	if ([tmp objectForKey:@"subjects"] != NULL){
		actionsubjectarray = [[tmp objectForKey:@"subjects"] retain];
	}
	
	if ([tmp objectForKey:@"actions"] != NULL){
		actionarray = [[tmp objectForKey:@"actions"] retain];
	}
	
	actionsubjectarrayindex = 0;
	actionarrayindex = 0;
	actiondevicesindex = 0;
	
	NSString *subject = [actionsubjectarray objectAtIndex:++actionsubjectarrayindex % [actionsubjectarray count]];
	[self updateActionSelections:subject];	
}

+(NSString *) lookupImage:(NSString*)identity state:(NSString*)state{
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:identity];
	return [images objectForKey:state];
}

+(NSString *) currentSubjectOwner{
	return [ownership objectAtIndex:ownershipindex % [ownership count]];	
}

+(NSString *) nextSubjectOwner{
	NSString *next =  [ownership objectAtIndex:++ownershipindex % [ownership count]];
	[devices release];
	devices =  [[ownerLookup objectForKey:[self currentSubjectOwner]] retain];
	devicesindex = 0;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"subjectOwnerChange" object:nil userInfo:nil];
	return next;
}

+(NSString *) nextSubjectOwnerImage{
	return [self lookupImage: [self nextSubjectOwner] state:@"main"];
}

+(NSString *) currentSubjectDevice{
	return [devices objectAtIndex:devicesindex % [devices count]];
}

+(NSString *) nextSubjectDevice{
	return [devices objectAtIndex:++devicesindex % [devices count]];
}

+(NSString *) nextSubjectDeviceImage{
	return [self lookupImage: [self nextSubjectDevice] state:@"main"];
}

+(NSString *) currentSubjectDeviceImage{
	return [self lookupImage: [self currentSubjectDevice] state:@"main"];
}


+(NSString *) nextConditionViewController{
	return nil;
}

+(NSString *) nextActionViewController{
	
	currentActionType = [actionvcsarray objectAtIndex:++actionvcsindex % [actionvcsarray count]];
	//reset all of our indexes.
	
	actionsubjectarrayindex = 0;
	actionarrayindex = 0;
	actiondevicesindex = 0;
	
	NSDictionary *tmp = [actionLookup objectForKey:currentActionType];
	
	
	if (actionsubjectarray != NULL)
		[actionsubjectarray release];
	if (actionarray != NULL)
		[actionarray release];
	
	if ([tmp objectForKey:@"subjects"] != NULL){
		actionsubjectarray = [[tmp objectForKey:@"subjects"] retain];
		NSString *subject = [actionsubjectarray objectAtIndex:actionsubjectarrayindex];
		[self updateActionSelections:subject];
	}
	
	if ([tmp objectForKey:@"actions"] != NULL){
		actionarray = [[tmp objectForKey:@"actions"] retain];
	}else{
		actionarray = NULL;	
	}
	
	return [actionvcs objectForKey:currentActionType];
}

+(NSString *) currentActionSubject{
	return [actionsubjectarray objectAtIndex:actionsubjectarrayindex % [actionsubjectarray count]];
}

+(NSString *) nextActionSubject{
	if (actionsubjectarray == NULL)
		return NULL;
	
	NSString *subject = [actionsubjectarray objectAtIndex:++actionsubjectarrayindex % [actionsubjectarray count]];
	[self updateActionSelections:subject];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionChange" object:nil userInfo:nil];
	
	return subject;
}

+(NSString *) currentActionSubjectImage{
	NSString *subject = [self currentActionSubject];
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:subject];
	NSString *image = [images objectForKey:currentActionType];
		NSLog(@"firing a notificaton change for imahe %@", image);
	NSDictionary* dict = [NSDictionary dictionaryWithObject:image forKey:@"action"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
	
	return image;//[images objectForKey:currentActionType];
}

+(NSString *) nextActionSubjectImage{
	NSString *subject = [self nextActionSubject];
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:subject];
	NSString *image = [images objectForKey:currentActionType];
		NSLog(@"firing a notificaton change for imahe %@", image);
	NSDictionary* dict = [NSDictionary dictionaryWithObject:image forKey:@"action"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
	return image;
	//return [images objectForKey:currentActionType];
}


+(NSString *) nextAction{
	if (actionarray == NULL){
		return NULL;
	}
	return [actionarray objectAtIndex:++actionarrayindex % [actionarray count]];
}


+(NSString *) currentAction{
	return [actionarray objectAtIndex:actionarrayindex % [actionarray count]];
}

+(NSString *) currentActionImage{
	NSString *action = [self currentAction];
	
	if (action == NULL){
		NSString *device = [actiondevices objectAtIndex:actiondevicesindex % [actiondevices count]];
		NSString *image = [self lookupImage:device state:currentActionType];
		NSDictionary* dict = [NSDictionary dictionaryWithObject:image forKey:@"action"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
		return image;
		
	}
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:currentActionType];
	return [images objectForKey:action];
}

//TODO: This is nasty - need to fix to stop hardcoding 

+(NSString *) nextActionImage{
	
	NSString *action = [self nextAction];
	
	if (action == NULL){
		NSString *device = [actiondevices objectAtIndex:++actiondevicesindex % [actiondevices count]];
		NSString *image = [self lookupImage:device state:currentActionType];
		NSDictionary* dict = [NSDictionary dictionaryWithObject:image forKey:@"action"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
		return image;
	}
	
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:currentActionType];
	return [images objectForKey:action];
	
}

@end
