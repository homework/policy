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
-(void) initConditions;
-(NSString *) lookupImage:(NSString*)identity type:(NSString*)type state:(NSString*)state;
-(NSString *) currentSubjectDevice;
-(NSString *) nextSubjectDevice;
-(NSString *) currentSubjectOwner;
-(NSString *) nextSubjectOwner;
-(NSString *) currentActionSubject;
-(NSString *) nextActionSubject;
-(NSString *) nextAction;
-(NSString *) currentAction;
-(void) updateActionOptions:(NSString *)subject;

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

static NSArray* actionoptionsarray;
static int actionoptionsarrayindex;

static NSArray* actiondevices;
static int actiondevicesindex;


static NSArray* conditions;
static int conditionindex;

static NSDictionary* conditionvcs;
static NSArray* conditionvcsarray;
static int conditionvcsindex;

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
            conditionvcs = (NSDictionary *) [[controllers objectForKey:@"conditions"] retain];            
            [self initConditions];
            
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

-(void) initConditions{
    conditionvcsarray = (NSArray*) [[conditionvcs allValues] retain];
    conditionvcsindex = 0;
}

-(void) initActions{
	
	actionvcsarray = (NSArray *) [[actionvcs allKeys] retain];
	actionvcsindex = 0;
    
    /*
     * Set the current action type (block, notify etc).
     */
	currentActionType = [actionvcsarray objectAtIndex:actionvcsindex];
    
    /*
     * Get the relevant dictionary for the current action type...
     */
	NSDictionary *tmp = [actionLookup objectForKey:currentActionType];
	
    /*
     * Get set the subject array for the current action type, and initialise the index to point to the first one
     */
	if ([tmp objectForKey:@"subjects"] != NULL){
		actionsubjectarray = [[tmp objectForKey:@"subjects"] retain];
	}
    actionsubjectarrayindex = 0;
    
    /*
     * For the currently selected subject, set the options array and point to the first option  
     */
    
     NSString *subject = [self currentActionSubject];
    
	if ([tmp objectForKey:@"options"] != NULL){
        NSDictionary* tmpoptdict = [tmp objectForKey:@"options"];
        actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
        //for (NSString *option in actionoptionsarray){
         //   NSLog(@"added option %@", option);
        //}
        actionoptionsarrayindex = 0;
    }
	
	//actionarrayindex = 0;
	//actiondevicesindex = 0;
	
	//NSString *subject = [actionsubjectarray objectAtIndex:++actionsubjectarrayindex % [actionsubjectarray count]];
	//NSLog(@"updating action selections for subject %@", subject);
   // [self updateActionSelections:subject];	
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

#pragma mark * Condition frames (public)

-(NSString*) currentCondition{
    return (NSString*) [conditions objectAtIndex:conditionindex % [conditions count]];
}

-(NSString*) nextCondition{
    NSString *condition = (NSString*) [conditions objectAtIndex:++conditionindex % [conditions count]];
    NSDictionary* dict = [NSDictionary dictionaryWithObject:condition forKey:@"condition"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"conditionChange" object:nil userInfo:dict];
    return condition;
}

#pragma mark * Action frames (private)


/*
-(void) updateActionSelections:(NSString *)subject{
	
	if ([currentActionType isEqualToString:@"block"]){
		if (actiondevices != NULL)
			[actiondevices release];
		
		actiondevices =  [[ownerLookup objectForKey:subject] retain];
		actiondevicesindex = 0;
	}
}*/



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
	[self updateActionOptions:subject];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionChange" object:nil userInfo:nil];
	
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subject,@"action",currentActionType,@"type",nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
	
	return subject;
}

-(void) updateActionOptions:(NSString *) subject{
    if (actionoptionsarray != NULL){
        [actionoptionsarray release];
    }
    NSDictionary *tmp = [actionLookup objectForKey:currentActionType];
    if ([tmp objectForKey:@"options"] != NULL){
        NSLog(@"setting options for the action %@,  subject %@", currentActionType, subject);
        NSDictionary* tmpoptdict = [tmp objectForKey:@"options"];
        actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
        actionoptionsarrayindex = 0;
    }
}


-(NSString *) nextAction{
	if (actionoptionsarray == NULL){
		return NULL;
	}
	return [actionoptionsarray objectAtIndex:++actionoptionsarrayindex % [actionoptionsarray count]];
}


-(NSString *) currentAction{
    if (actionoptionsarray == NULL){
		return NULL;
	}
    for (NSString *option in actionoptionsarray){
       NSLog(@"erm option %@", option);
    }
   return [actionoptionsarray objectAtIndex:actionoptionsarrayindex % [actionoptionsarray count]];
}

#pragma mark * Public controller getters

-(NSString *) nextActionViewController{
	
	currentActionType = [actionvcsarray objectAtIndex:++actionvcsindex % [actionvcsarray count]];
    NSLog(@"current action type is now %@", currentActionType);

	//actiondevicesindex = 0;
	
	NSDictionary *tmp = [actionLookup objectForKey:currentActionType];
	
	
	if (actionsubjectarray != NULL)
		[actionsubjectarray release];
	if (actionoptionsarray != NULL)
		[actionoptionsarray release];
	
	if ([tmp objectForKey:@"subjects"] != NULL){
		actionsubjectarray = [[tmp objectForKey:@"subjects"] retain];
        actionsubjectarrayindex = 0;
		NSString *subject = [actionsubjectarray objectAtIndex:actionsubjectarrayindex];
	//	[self updateActionSelections:subject];
	}
	
	if ([tmp objectForKey:@"options"] != NULL){
        NSLog(@"setting up action array....");
        NSString* subject = [self currentActionSubject];
        NSDictionary* tmpoptdict = [tmp objectForKey:@"options"];
        actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
        actionoptionsarrayindex = 0;
         NSLog(@"done setting up action array....");
	}
    NSString* controller = [self currentActionViewController];// [actionvcs objectForKey:currentActionType];
    NSLog(@"firing an action type change for controller %@", controller);
    NSDictionary* dict = [NSDictionary dictionaryWithObject:controller forKey:@"controller"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTypeChange" object:nil userInfo:dict];
	return controller;
}

-(NSString *) currentActionViewController{
   // currentActionType = [actionvcsarray objectAtIndex:actionvcsindex % [actionvcsarray count]];
    NSString* controller = [actionvcs objectForKey:currentActionType];
    return controller;
}

-(NSString *) currentConditionViewController{
    return [conditionvcsarray objectAtIndex:conditionvcsindex % [conditionvcsarray count]];
}

-(NSString *) nextConditionViewController{
	return [conditionvcsarray objectAtIndex:++conditionvcsindex % [conditionvcsarray count]];
}

-(NSString*) getConditionResultController:(NSString*) condition{
    return [conditionresultvcs objectForKey:condition];
}

-(NSString*) getConditionViewController:(NSString*)condition{
    return [conditionvcs objectForKey:condition];
}

#pragma mark * Public image getters


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
    
    	
    //if (action == NULL){
		//NSString *device = [actiondevices objectAtIndex:actiondevicesindex % [actiondevices count]];
		NSLog(@"looking up current action image....%@ for type %@",action, currentActionType);

        NSString *image = [self lookupImage:action type:currentActionType state:@"action"];
        
		NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:action,@"action",currentActionType,@"type",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
		return image;
		
	//}
	//NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:currentActionType];
	//return [images objectForKey:action];
}

-(NSString *) nextActionImage{
	
	NSString *action = [self nextAction];
	 
    NSLog(@"looking up current action image....%@ for type %@",action, currentActionType);
    
    NSString *image = [self lookupImage:action type:currentActionType state:@"action"];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:action,@"action",currentActionType,@"type",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
    return image;
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

-(void) setCondition:(NSString *)condition{
    
    int index = 0;
    
    for (NSString* acondition in conditions){
        if ([acondition isEqualToString:condition]){
            conditionindex = index;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"conditionLoaded" object:nil userInfo:nil];
        }
        index+=1;
    }
}

/*
 * Action  =   notify / block etc
 * Subject =   mum / dad  etc
 * Option  =   tweet / notify etc or nil
 */

-(void) setAction:(NSString *) action subject:(NSString*) subject option:(NSString*)option{
    

  	actiondevicesindex = 0;
    
    int index = 0;
    //first check to see if action exists
    NSDictionary *tmp = [actionLookup objectForKey:action];
    
    if (tmp != nil){
        //set the index for the current action;
       
        NSArray *subjects = [tmp objectForKey:@"subjects"];
        
        if (subjects != nil){
            index = 0;
            for (NSString* asubject in subjects){
                if ([asubject isEqualToString:subject]){
                    
                    if (actionsubjectarray != NULL)
                        [actionsubjectarray release];
                   
                    actionsubjectarray = [subjects retain];
                    actionsubjectarrayindex = index;
                    currentActionType = action;
                    
                    NSString *subject = [actionsubjectarray objectAtIndex:actionsubjectarrayindex];
                    
                    [self updateActionOptions:subject];
                    
                    //set the view controller index...
                   
                    index = 0;
                    for (NSString* anaction in actionvcsarray){
                        NSLog(@"chceking %@ against %@", anaction, action);
                        if ([anaction isEqualToString:action]){
                            actionvcsindex = index;
                            break;
                        }
                        index += 1;
                    }
                   
                    //have set the action and subjects, now need to do options...
                    
                    if (option != nil){
                       
                        if (actionoptionsarray != NULL)
                            [actionoptionsarray release];
                        
                        if ([tmp objectForKey:@"options"] != NULL){
            
                            NSDictionary* tmpoptdict = [tmp objectForKey:@"options"];
                            actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
                            actionoptionsarrayindex = 0;

                            
                            index = 0;
                            
                            for(NSString* anoption in actionoptionsarray){
                                if ([anoption isEqualToString:option]){
                                    actionoptionsarrayindex = index;
                                    break;
                                }
                                index +=1;
                            }
                        }
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionLoaded" object:nil userInfo:nil];
                    NSString* controller = [self currentActionViewController];// [actionvcs objectForKey:currentActionType];
                    NSLog(@"firing an action type change for controller %@", controller);
                    NSDictionary* dict = [NSDictionary dictionaryWithObject:controller forKey:@"controller"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTypeChange" object:nil userInfo:dict];
                    break;
                }
                index += 1;
            }           
        }
    }
}

@end
