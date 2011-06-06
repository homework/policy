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
-(NSString *) nextSubjectDevice;
-(NSString *) currentSubjectOwner;
-(NSString *) nextSubjectOwner;
-(NSString *) nextActionSubject;
-(NSString *) nextAction;
-(NSString *) nextCondition;

-(void) updateActionOptions:(NSString *)subject;

@end

@implementation Catalogue

@synthesize conditionArguments;

#pragma mark *data structure for associating entities with images

static NSDictionary* imageLookup;


#pragma mark *data structures for subjects

static NSDictionary* subjectLookup;     //mapping from owner name to array of macaddresses

static NSArray* ownership;              //array of each of the owners (e.g. mum, dad etc) 
static int ownershipindex;              //current index in the owners array

static NSArray* devices;                //array of each of the currently selected owner's devices
static int devicesindex;                //current index of the currently selected owners's devices.

#pragma mark *data structures for conditions

static NSDictionary* conditionLookup;   //mapping of condition name to expected arguments
static NSDictionary* conditionvcs;      //mapping of condition name to associated view controller

static NSArray* conditions;             //array of the condition names (e.g. bandwidth, visits, time)
static int conditionindex;              //index of currently selectd condition

static NSArray* conditionvcsarray;      //array of condition view contollers 
static int conditionvcsindex;           //curretly selected condition view controller


#pragma mark *data structures for actions

static NSDictionary* actionLookup;      //mapping of action type to action details (block, notofy etc)
static NSDictionary* actionvcs;         //mapping of action type to associated view controller

static NSString* currentActionType;     //the currently selectd action type (block, notify etc).

       
static NSArray* actionvcsarray;         //array of action view controllers 
static int actionvcsindex;              //currently selected action view controller

static NSArray* actionsubjectarray;     //array of possible subjects (i.e macaddrs) for current action
static int actionsubjectarrayindex;     //currently selected subject

static NSArray* actionoptionsarray;     //array of possible options (i.e. tweet, notify) or (device x, device y)
static int actionoptionsarrayindex;     //currently selected option.


#pragma mark *data structures for results

static NSDictionary* conditionresultvcs; //mapping of currently selected condition to associated result view controller

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
            NSDictionary *controllers = (NSDictionary *) [main objectForKey:@"controllers"];
            
            /*
             * Generate the arrays to handle navigation thorugh owners and their devices in the
             * subject pane (i.e first pane in the comic).
            
             */
            
            subjectLookup = [(NSDictionary *) [navigation objectForKey:@"subjects"] retain];
            
            ownership = [[subjectLookup allKeys] retain];
            ownershipindex = 0;
            
            devices =  [[subjectLookup objectForKey:[self currentSubjectOwner]] retain];
            devicesindex = 0;
            
            
            /*
             * Generate the arrays to handle navigation through conditions and associated view controllers
             */
            conditionLookup = (NSDictionary *) [navigation objectForKey:@"conditions"];
            
            
            
            conditions = [[conditionLookup allKeys ]retain];
            conditionindex = -1;
            
            conditionvcs = (NSDictionary *) [[controllers objectForKey:@"conditions"] retain];
            [self initConditions];
            
            
            /*
             * Generate the arrays to handle navigation through actions and associated view controllers
             */
            actionLookup = [(NSDictionary *) [navigation objectForKey:@"actions"] retain];
            actionvcs = (NSDictionary *) [[controllers objectForKey:@"actions"] retain];
            [self initActions];
            
            
            /*
             * Generate the arrays to handle navigation through results and associated view controllers
             */
            conditionresultvcs = (NSDictionary *) [[controllers objectForKey:@"results"] retain];
                       
            
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
        actionoptionsarrayindex = 0;
    }
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
	devices =  [[subjectLookup objectForKey:[self currentSubjectOwner]] retain];
	devicesindex = 0;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"subjectOwnerChange" object:nil userInfo:nil];
	return next;
}

#pragma mark * Condition frames (public)

-(NSString*) currentCondition{
    NSString *condition = (NSString*) [conditions objectAtIndex:conditionindex % [conditions count]];
    return condition;
}

-(NSString*) nextCondition{
    NSString *condition = (NSString*) [conditions objectAtIndex:++conditionindex % [conditions count]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"conditionChange" object:nil userInfo:nil];
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
    if ([tmp objectForKey:@"arguments"] != NULL){
        NSDictionary* tmpoptdict = [tmp objectForKey:@"arguments"];
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

-(NSString *) currentActionType{
    return currentActionType;
}

-(NSString *) currentActionSubject{
    NSString *subject = [actionsubjectarray objectAtIndex:actionsubjectarrayindex % [actionsubjectarray count]];
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:subject,@"action",currentActionType,@"type",nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
    return subject;
}

-(NSString *) currentAction{
    if (actionoptionsarray == NULL)
		return NULL;
	
   return [actionoptionsarray objectAtIndex:actionoptionsarrayindex % [actionoptionsarray count]];
}

#pragma mark * Public controller getters

-(NSString *) nextActionViewController{
	
	currentActionType = [actionvcsarray objectAtIndex:++actionvcsindex % [actionvcsarray count]];
	NSDictionary *tmp = [actionLookup objectForKey:currentActionType];
	
	
	if (actionsubjectarray != NULL)
		[actionsubjectarray release];
	if (actionoptionsarray != NULL)
		[actionoptionsarray release];
	
	if ([tmp objectForKey:@"subjects"] != NULL){
		actionsubjectarray = [[tmp objectForKey:@"subjects"] retain];
        actionsubjectarrayindex = 0;
	}
	
	if ([tmp objectForKey:@"arguments"] != NULL){
        NSString* subject = [self currentActionSubject];
        NSDictionary* tmpoptdict = [tmp objectForKey:@"arguments"];
        actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
        actionoptionsarrayindex = 0;
	}
    NSString* controller = [self currentActionViewController];// [actionvcs objectForKey:currentActionType];
   
    NSDictionary* dict = [NSDictionary dictionaryWithObject:controller forKey:@"controller"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTypeChange" object:nil userInfo:dict];
	return controller;
}

-(NSString *) currentActionViewController{
    return [actionvcs objectForKey:currentActionType];
}

-(NSString *) currentConditionViewController{
    return [conditionvcsarray objectAtIndex:conditionvcsindex % [conditionvcsarray count]];
}

-(NSString *) nextConditionViewController{
     
	NSString *cc = [conditionvcsarray objectAtIndex:++conditionvcsindex % [conditionvcsarray count]];
    NSLog(@"current vc is now  %@", cc);
    return cc;
}

-(NSString*) getConditionResultController{
    //return [conditionresultvcs objectForKey:condition];
    return [conditionresultvcs objectForKey:[self currentCondition]];
}

-(NSString*) getConditionViewController{
    NSLog(@"current condition is now %@", [self currentCondition]);
    return [conditionvcs objectForKey:[self currentCondition]];
}

#pragma mark * Public image getters


-(NSString*) getConditionImage{
    NSDictionary *dict = (NSDictionary *) [imageLookup objectForKey:[self currentCondition]];
    return [dict objectForKey:@"main"];
}

-(NSString*) getConditionResultImage{
    NSDictionary *dict = (NSDictionary *) [imageLookup objectForKey:[self currentCondition]];
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
    NSString *image = [self lookupImage:action type:currentActionType state:@"action"];
        
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:action,@"action",currentActionType,@"type",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:dict];
    return image;
		
}

-(NSString *) nextActionImage{
	NSString *action = [self nextAction];
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
   
    NSDictionary* tmpdevices = [subjectLookup objectForKey:owner];
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

-(void) setAction:(NSString *) action subject:(NSString*) subject option:(NSString*)argument{
    
    
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
                        if ([anaction isEqualToString:action]){
                           
                            actionoptionsarrayindex = index;
                            actionvcsindex = index;
                            break;
                        }
                        index += 1;
                    }
                   
                    //have set the action and subjects, now need to do options...
                    
                    if (argument != nil){
                       
                        if (actionoptionsarray != NULL)
                            [actionoptionsarray release];
                        
                        if ([tmp objectForKey:@"arguments"] != NULL){
            
                            NSDictionary* tmpoptdict = [tmp objectForKey:@"arguments"];
                         
                            actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
                            
                            actionoptionsarrayindex = 0;
                            
                            
                            index = 0;
                            
                            for(NSString* anargument in actionoptionsarray){
                                if ([anargument isEqualToString:argument]){
                                    actionoptionsarrayindex = index;
                                    break;
                                }
                                index +=1;
                            }
                        }
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionLoaded" object:nil userInfo:nil];
                    
                    NSString* controller = [self currentActionViewController];
                    
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
