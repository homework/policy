//
//  Catalogue.m
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Catalogue.h"


@interface Catalogue ()

-(void) initActions;
-(NSString *) lookupImage:(NSString*)identity type:(NSString*)type state:(NSString*)state;
-(NSString *) currentSubjectDevice;
-(NSString *) nextSubjectDevice;
-(NSString *) currentSubjectOwner;
-(NSString *) nextSubjectOwner;
-(NSString *) nextCondition;
-(NSString *) currentActionSubject;
-(NSString *) nextActionSubject;
-(NSString *) nextAction;
-(NSString *) currentAction;
-(void) updateActionSelections:(NSString *)subject;

@end

@implementation Catalogue



static NSDictionary* imageLookup;
static NSDictionary* ownerLookup;
static NSDictionary* conditionresultvcs;


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

static NSArray* conditions;
static int conditionindex;

static NSString* currentActionType;



+ (Catalogue *)sharedCatalogue
{
    static  Catalogue * sCatalogue;
    
    if (sCatalogue == nil) {
        @synchronized (self) {
            sCatalogue = [[Catalogue alloc] init];
            assert(sCatalogue != nil);
        }
    }
    return sCatalogue;
}

- (id)init
{
    // any thread, but serialised by +sharedManager
    self = [super init];
    if (self != nil) {
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
            
            NSDictionary *navigation =  (NSDictionary *) [main objectForKey:@"navigation"];
            ownerLookup = [(NSDictionary *) [navigation objectForKey:@"subjects"] retain];
            actionLookup = [(NSDictionary *) [navigation objectForKey:@"actions"] retain];
            
            
            conditions = (NSArray *) [[navigation objectForKey:@"conditions"] retain];
            conditionindex = -1;//0;

            
            NSDictionary *controllers = (NSDictionary *) [main objectForKey:@"controllers"];
            actionvcs = (NSDictionary *) [[controllers objectForKey:@"actions"] retain];
            conditionresultvcs = (NSDictionary *) [[controllers objectForKey:@"results"] retain];
                        
            
            [self initActions];
            ownership = [[ownerLookup allKeys] retain];
            ownershipindex = 0;
            
            devices =  [[ownerLookup objectForKey:[self currentSubjectOwner]] retain];
            devicesindex = 0;
            
            
        }
    }
    return self;
}

#pragma mark * Private methods

-(void) initActions{
	
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


-(NSString *) lookupImage:(NSString*)identity type:(NSString*)type state:(NSString*)state{
    
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:identity];
    if (state == nil){
        return [images objectForKey:type];
    }
    NSDictionary *dict = (NSDictionary *) [images objectForKey:type];
	return [dict objectForKey:state];
}




#pragma mark * Subject frames (private)

-(NSString *) currentSubjectDevice{
	return [devices objectAtIndex:devicesindex % [devices count]];
}

-(NSString *) nextSubjectDevice{
	return [devices objectAtIndex:++devicesindex % [devices count]];
}

-(NSString *) currentSubjectOwner{
	return [ownership objectAtIndex:ownershipindex % [ownership count]];	
}

-(NSString *) nextSubjectOwner{
	NSString *next =  [ownership objectAtIndex:++ownershipindex % [ownership count]];
	[devices release];
	devices =  [[ownerLookup objectForKey:[self currentSubjectOwner]] retain];
	devicesindex = 0;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"subjectOwnerChange" object:nil userInfo:nil];
	return next;
}

#pragma mark * Condition frames (private)

-(NSString*) nextCondition{
    NSString *condition = (NSString*) [conditions objectAtIndex:++conditionindex % [conditions count]];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:condition forKey:@"condition"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"conditionChange" object:nil userInfo:dict];
    return condition;
}

#pragma mark * Action frames (private)


-(void) updateActionSelections:(NSString *)subject{
	
	if ([currentActionType isEqualToString:@"block"]){
		if (actiondevices != NULL)
			[actiondevices release];
		
		actiondevices =  [[ownerLookup objectForKey:subject] retain];
		actiondevicesindex = 0;
	}
}



-(NSString *) currentActionSubject{
    NSString *subject = [actionsubjectarray objectAtIndex:actionsubjectarrayindex % [actionsubjectarray count]];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subject,@"action",currentActionType,@"type",nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
    return subject;
}

-(NSString *) nextActionSubject{
	if (actionsubjectarray == NULL)
		return NULL;
	
	NSString *subject = [actionsubjectarray objectAtIndex:++actionsubjectarrayindex % [actionsubjectarray count]];
	[self updateActionSelections:subject];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionChange" object:nil userInfo:nil];
	
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subject,@"action",currentActionType,@"type",nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
	
	return subject;
}


-(NSString *) nextAction{
	if (actionarray == NULL){
		return NULL;
	}
	return [actionarray objectAtIndex:++actionarrayindex % [actionarray count]];
}


-(NSString *) currentAction{
    if (actionarray == NULL){
		return NULL;
	}
   return [actionarray objectAtIndex:actionarrayindex % [actionarray count]];
}

#pragma mark * Public controller getters

-(NSString *) nextActionViewController{
	
	currentActionType = [actionvcsarray objectAtIndex:++actionvcsindex % [actionvcsarray count]];
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
	
	if ([tmp objectForKey:@"options"] != NULL){
		actionarray = [[tmp objectForKey:@"options"] retain];
	}else{
		actionarray = NULL;	
	}
    NSString* controller = [actionvcs objectForKey:currentActionType];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:controller forKey:@"controller"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTypeChange" object:nil userInfo:dict];
	return controller;
}

-(NSString *) nextConditionViewController{
	return nil;
}

-(NSString*) getConditionResultController:(NSString*) condition{
    return [conditionresultvcs objectForKey:condition];
}

#pragma mark * Public image getters

-(NSString*) nextConditionImage{
    NSString* condition = [self nextCondition];
    NSString *conditionImage = [self getConditionImage:condition];
    return conditionImage;
}

-(NSString*) getConditionImage:(NSString *) condition{
    NSDictionary *dict = (NSDictionary *) [imageLookup objectForKey:condition];
    return [dict objectForKey:@"main"];
}

-(NSString*) getConditionResultImage:(NSString *) condition{
    NSDictionary *dict = (NSDictionary *) [imageLookup objectForKey:condition];
    return [dict objectForKey:@"result"];
}

-(NSString *) currentActionSubjectImage{
	NSString *subject = [self currentActionSubject];
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:subject];
    NSDictionary *action =  (NSDictionary*) [images objectForKey:currentActionType];
    NSString *image = [action objectForKey:@"action"];
    return image;
}

-(NSString *) nextActionSubjectImage{
	NSString *subject = [self nextActionSubject];
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:subject];
	NSDictionary *action =  (NSDictionary*) [images objectForKey:currentActionType];
    NSString *image = [action objectForKey:@"action"];
    return image;
}


-(NSString *) currentActionImage{
	NSString *action = [self currentAction];
	   
	if (action == NULL){
		NSString *device = [actiondevices objectAtIndex:actiondevicesindex % [actiondevices count]];
		
        NSString *image = [self lookupImage:device type:currentActionType state:@"action"];
        
		NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:device,@"action",currentActionType,@"type",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
		return image;
		
	}
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:currentActionType];
	return [images objectForKey:action];
}

-(NSString *) nextActionImage{
	
	NSString *action = [self nextAction];
	 
	if (action == NULL){
		NSString *device = [actiondevices objectAtIndex:++actiondevicesindex % [actiondevices count]];
		NSString *image = [self lookupImage:device type:currentActionType state:@"action"];
		NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:device,@"action",currentActionType,@"type",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
		return image;
	}
	
    NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:currentActionType];
	return [images objectForKey:action];
}

-(NSString *) nextSubjectOwnerImage{
	return [self lookupImage: [self nextSubjectOwner] type:@"main" state:nil];
}

-(NSString *) currentSubjectOwnerImage{
	return [self lookupImage: [self currentSubjectOwner] type:@"main" state:nil];
}

-(NSString *) nextSubjectDeviceImage{
	return [self lookupImage: [self nextSubjectDevice] type:@"main" state:nil];
}

-(NSString *) currentSubjectDeviceImage{
	return [self lookupImage: [self currentSubjectDevice] type:@"main" state:nil];
}

-(NSString*) getActionResultImage:(NSString*) subject action:(NSString*)action{
    NSDictionary *subj = (NSDictionary *) [imageLookup objectForKey:subject];
    NSDictionary *dict = (NSDictionary *) [subj objectForKey:action];
    return [dict objectForKey:@"result"];
}

#pragma mark * Public policy setters

-(void) setSubject:(NSString *)owner device:(NSString*) device{
   
    NSDictionary* tmpdevices = [ownerLookup objectForKey:owner];
    int index = 0;
    
    for (NSString *device in tmpdevices){
        
        if ([device isEqualToString:device]){
            [devices release];
            devices = [tmpdevices retain];
            devicesindex = index;
            
            ownershipindex = 0;
            
            for (NSString * tmpowner in ownership){
                if ([tmpowner isEqualToString:owner]){
                    break;
                }
                ownershipindex+=1;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"subjectOwnerLoaded" object:nil userInfo:nil];
            return;
        }
        index += 1;
    }    
}

@end
