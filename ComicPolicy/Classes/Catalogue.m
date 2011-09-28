//
//  Catalogue.m
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Catalogue.h"
#import "NetworkManager.h"
#import "ASIHTTPRequest.h"

@interface Catalogue ()

-(void) initActions;
-(void) initConditions;
-(NSString *) lookupImage:(NSString*)identity type:(NSString*)type state:(NSString*)state;
-(NSString *) nextSubjectDevice;
-(NSString *) nextSubjectOwner;
-(NSString *) nextActionSubject;
-(NSString *) nextAction;
-(void) updateActionOptions:(NSString *)subject;
-(void) mapDevicesToOwners;

//-(void)addedRequestComplete:(ASIHTTPRequest *)request;


@end

@implementation Catalogue

#pragma mark *data structures for image lookups

NSDictionary *imageLookup;

NSDictionary *subjectToBundleLookup;

NSDictionary *imageBundles;

#pragma mark *data structures for subjects

static NSDictionary* subjectLookup;       //mapping from owner name to array of macaddresses
static NSMutableDictionary* deviceLookup; //reverse lookup: device to owner

static NSArray* subjectownership;              //array of each of the owners (e.g. mum, dad etc) 
static int subjectownershipindex;              //current index in the owners array

static NSArray* devices;                //array of each of the currently selected owner's devices
static int devicesindex;                //current index of the currently selected owners's devices.

static NSMutableArray* alldevices;
static NSMutableArray* allpeople;

#pragma mark *data structures for conditions

static NSDictionary* conditionLookup;   //mapping of condition name to expected arguments
static NSDictionary* conditionvcs;      //mapping of condition name to associated view controller

static NSArray* conditions;             //array of the condition names (e.g. bandwidth, visits, time)
static int conditionindex;              //index of currently selectd condition

static NSArray* conditionvcsarray;      //array of condition view contollers 
static int conditionvcsindex;           //curretly selected condition view controller


#pragma mark *data structures for actions

static NSMutableDictionary* actionLookup;      //mapping of action type to action details (block, notofy etc)
static NSDictionary* actionvcs;         //mapping of action type to associated view controller

static NSString* currentActionType;     //the currently selectd action type (block, notify, prioritise etc).

static NSArray* actionvcsarray;         //array of action view controllers 
static int actionvcsindex;              //currently selected action view controller

static NSArray* actionsubjectarray;     //array of possible subjects (i.e macaddrs) for current action
static int actionsubjectarrayindex;     //currently selected subject

static NSArray* actionoptionsarray;     //array of possible options (i.e. tweet, notify) or (device x, device y)
static int actionoptionsarrayindex;     //currently selected option.


#pragma mark *data structures for results

static NSDictionary* conditionresultvcs; //mapping of currently selected condition to associated result view controller

#pragma mark *data structure for device metadata

static NSDictionary* devicemetadata;


#pragma mark *data structure for policy navigation
NSMutableDictionary *tree;


@synthesize currentConditionArguments;
@synthesize currentActionArguments;

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
        self.currentConditionArguments = [[NSMutableDictionary alloc] init];
        self.currentActionArguments = [[NSMutableDictionary alloc] init];
        // [self readInCatalogue];
        
        
    }
    return self;
}




-(void) parseCatalogue:(NSString*) catalogue{
    
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSDictionary *data = nil;
    
    if (catalogue != nil)
        data  = (NSDictionary *) [jsonParser objectWithString:catalogue error:nil];
    
    if (data == nil){
        NSLog(@"READING IN LOCAL COPY OF CATALOGUE");
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cataloguev2" ofType:@"json"];
        NSString *content = [[NSString alloc] initWithContentsOfFile:filePath];
        data  = (NSDictionary *) [jsonParser objectWithString:content error:nil];
    }else{
        NSLog(@"successfully read in the catalogue data");
    }
    [data retain];
    
    
    NSDictionary *main = (NSDictionary *) [data objectForKey:@"catalogue"];
    
    imageLookup = (NSDictionary *) [[main objectForKey:@"images"] retain];
    
    NSDictionary *navigation =  (NSDictionary *) [main objectForKey:@"navigation"];
    NSDictionary *controllers = (NSDictionary *) [main objectForKey:@"controllers"];
    
    /*
     * Generate the arrays to handle navigation thorugh owners and their devices in the
     * subject pane (i.e first pane in the comic).
     
     */
    
    subjectLookup = [(NSDictionary *) [navigation objectForKey:@"subjects"] retain];
    
    subjectownership = [[subjectLookup allKeys] retain];
    subjectownershipindex = 0;
    
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
    
    tree = [(NSDictionary *) [navigation objectForKey:@"conditionactiontree"] retain];
    actionLookup = [(NSDictionary *) [navigation objectForKey:@"actions"] retain];
    
    NSLog(@"action lookup is %@", actionLookup);
    
    
    
    actionvcs = (NSDictionary *) [[controllers objectForKey:@"actions"] retain];
    [self initActions];
    
    
    /*
     * Generate the arrays to handle navigation through results and associated view controllers
     */
    conditionresultvcs = (NSDictionary *) [[controllers objectForKey:@"results"] retain];
    
    
    
    [self mapDevicesToOwners];
    
}



-(void) parseCatalogueNEW:(NSString*) catalogue{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cataloguev2" ofType:@"json"];
    
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath];
    
    NSDictionary *data  = (NSDictionary *) [[jsonParser objectWithString:content error:nil] retain];
    
    NSDictionary *main = (NSDictionary *) [data objectForKey:@"catalogue"];
    
    //read in the dynamic data
    [self readInDynamicData:[main objectForKey:@"dynamic"]];
    
    //read in the static data
    [self readInStaticData:[main objectForKey:@"static"]];
    
}

-(void) readInDynamicData:(NSDictionary *) dict{
    
    //set up the data structures for navigating the subjects
    
    [self initDynamicSubjects:dict];
   

}

-(void) readInStaticData:(NSDictionary *) dict{
    //The image bundles dictionary (maps image bundle name to a set of images)
    imageBundles =  [(NSDictionary *) [dict objectForKey:@"imagebundles"] retain];
    
    // Set up the array of condition view controllers
    imageLookup  =  [(NSDictionary *) [dict objectForKey:@"staticimages"] retain];
    
    [self initStaticConditions:dict];
    
    [self initStaticActions:dict];
}

-(void) initDynamicSubjects:(NSDictionary *) dict{
    
    // The mapping of subjects (devices and owners) to image bundles.
    subjectToBundleLookup = [(NSDictionary *) [dict objectForKey:@"bundlelookup"] retain];
    
    
    //The mapping of owners (i.e people) to arrays of devices that they own.
    subjectLookup         = [(NSDictionary *) [dict objectForKey:@"subjects"] retain];
    
    //Generate the list of all currently supported people
   
    allpeople = [[[NSMutableArray alloc] init] retain];
    
    for (NSString  *person in [subjectLookup allKeys]){
        if (![person isEqualToString:@"any"]){
            [allpeople addObject:person]; 
        }
    }
    
    //Create the list of all currently supported people
    alldevices = [[[NSMutableArray alloc] init] retain];

    for (NSString *key in allpeople){
        NSArray* devices = [subjectLookup objectForKey:key];
        NSLog(@"getting devices for key %@", key);
        for (NSString *device in devices){
            [alldevices addObject:device];
        }
    }
    NSLog(@"all devices is now %@", alldevices);
    
    //The array of all of the owners and an index to the currently selected owner
    subjectownership = [[subjectLookup allKeys] retain];
    subjectownershipindex = 0;
    
    //The array of devices that are owned by the currently selected subject owner
    devices =  [[subjectLookup objectForKey:[self currentSubjectOwner]] retain];
    devicesindex = 0;
    
    // generate the device metadata dictionary
    devicemetadata = [[(NSDictionary *) [dict objectForKey:@"metadata"] objectForKey:@"devices"] retain];

    //set up the data structure to provide the reverse mapping of device to owner
    [self mapDevicesToOwners];
}



-(void) initStaticConditions:(NSDictionary *) dict{
    
    NSDictionary *controllers = (NSDictionary *) [dict objectForKey:@"controllers"];
    
   
    conditionvcs = (NSDictionary *) [[controllers objectForKey:@"conditions"] retain];
    
    //the array that contains the names of the condition view controllers (for dynamic view controller creation)
    conditionvcsarray = (NSArray*) [[conditionvcs allValues] retain];
    conditionvcsindex = 0;
    
    //conditionLookup provides the mapping between condition names and associated arguments
    conditionLookup = (NSDictionary *) [dict objectForKey:@"conditions"];
    
    //the array that holds the set of condtions that can be traversed (visiting, timed, bandwidth etc) and its current index
    conditions = [[conditionLookup allKeys ]retain];
    conditionindex = -1;
    
    //create the default condition arguments for each condition type.
    for (NSString *condition in [conditionLookup allKeys]){
        NSDictionary *dictionary = [conditionLookup objectForKey:condition];
        NSDictionary *arguments = [dictionary objectForKey:@"arguments"];
        [currentConditionArguments  setObject:arguments forKey:condition];  
    }
}

-(void) initStaticActions:(NSDictionary *) dict{
    
    NSDictionary *controllers = (NSDictionary *) [dict objectForKey:@"controllers"];
    
    //the tree that represents the actions allowed for each condition type 
    tree = [(NSDictionary *) [dict objectForKey:@"conditionactiontree"] retain];
    
    //the dictionary of the actions that are supported by this UI
    //actionLookup = [(NSDictionary *) [dict objectForKey:@"actions"] retain];
    
    NSDictionary *actionsminified = (NSDictionary *) [dict objectForKey:@"actions"];

    actionLookup = [[NSMutableDictionary alloc] init];                                
    
    
    for (NSString* actiontype in [actionsminified allKeys]){
        
        if ([actiontype isEqualToString:@"block"]){
            NSMutableDictionary *blockdict = [[[NSMutableDictionary alloc] init] retain];
            NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] retain];
            for (NSString *device in alldevices){
               
                [dict setObject: [[NSArray alloc] initWithObjects:[deviceLookup objectForKey:device],nil] forKey:device];
            }
            
            NSMutableDictionary *arguments = [[[NSMutableDictionary alloc] init] retain];
            [arguments setObject:dict forKey:@"options"];
            [blockdict setObject:alldevices forKey:@"subjects"];
            [blockdict setObject:arguments forKey:@"arguments"];
            [actionLookup setObject:blockdict forKey:actiontype];

        }else if ([actiontype isEqualToString:@"notify"]){
            
            NSMutableDictionary *notifydict = [[[NSMutableDictionary alloc] init] retain];
            
            NSArray *options =  [(NSDictionary *) [actionsminified objectForKey:actiontype] objectForKey:@"options"];
            
            NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] retain];
            
            for (NSString *person in allpeople){
                [dict setObject:options forKey:person];
            }
            
            NSMutableDictionary *arguments = [[[NSMutableDictionary alloc] init] retain];
            [arguments setObject:dict forKey:@"options"];
            [notifydict setObject:allpeople forKey:@"subjects"];
            [notifydict setObject:arguments forKey:@"arguments"];
            [actionLookup setObject:notifydict forKey:actiontype];
        
        }else if ([actiontype isEqualToString:@"prioritise"]){
            
            NSMutableDictionary *prioritisedict = [[[NSMutableDictionary alloc] init] retain];
            NSArray *options =  [(NSDictionary *) [actionsminified objectForKey:actiontype] objectForKey:@"options"];
            
            NSMutableDictionary* dict = [[[NSMutableDictionary alloc] init] retain];
            
            for (NSString *device in alldevices){
                [dict setObject:options forKey:device];
            }
            
            NSMutableDictionary *arguments = [[[NSMutableDictionary alloc] init] retain];
            [arguments setObject:dict forKey:@"options"];
            [prioritisedict setObject:alldevices forKey:@"subjects"];
            [prioritisedict setObject:arguments forKey:@"arguments"];
            [actionLookup setObject:prioritisedict forKey:actiontype];
        }
    }
    
    NSLog(@"actionlookup is as follows %@", actionLookup);
    
    //done
    
    actionvcs = (NSDictionary *) [[controllers objectForKey:@"actions"] retain];
    
    [self initActions];
}


-(void) initActionsNEW{
    
    //reset the view controller array (i.e the array of action view controllers, which is dependent upon the current condition)
    if (actionvcsarray != nil){
        [actionvcsarray release];
        actionvcsarray = nil;
    }

    
    //reset the array of possible option associated with a particular action
    if (actionoptionsarray != nil){
        [actionoptionsarray release];
        actionoptionsarray = nil;        
    }
    
	
    //Now recreate each of these arrays.
    
    //recreate the action vcs array
	actionvcsarray = [(NSArray *) [tree objectForKey:[self currentCondition]] retain];
    actionvcsindex = 0;
    

    // Now set the current action type (block, notify etc).
	currentActionType = [actionvcsarray objectAtIndex:actionvcsindex];
    
    
    // Now...this needs to change..Get the relevant dictionary for the current action type...
     
	NSDictionary *tmp = [actionLookup objectForKey:currentActionType];
	
    /*
     * Get set the subject array for the current action type, and initialise the index to point to the first one
     */
    
    NSString *subj = [tmp objectForKey:@"subjects"];
    
	if (subj != NULL){
        if ([subj isEqualToString:@"people"]){
            actionsubjectarray = allpeople;
        }else{
            actionsubjectarray = alldevices;
        }
        actionsubjectarrayindex = 0;
	}
    
    
    //do we need to retain these arrays?...check this..
    
    /*
     * For the currently selected subject (i.e a device or a person) set the list of possible options
     * for now we hardcode this as it should not change until we support a new action type. This will
     * keep the config file small....
     */
    
    NSString *subject = [self currentActionSubject];
    
    //special case for now, which maps device to owner
    
    if ([currentActionType isEqualToString:@"block"]){ 
        actionoptionsarray  = [[[NSArray alloc] initWithObjects:[deviceLookup objectForKey:subject],nil] retain];
    }else{
        actionoptionsarray = [[tmp objectForKey:@"options"] retain];
    }
     
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTypeChange" object:nil userInfo:nil];
    
}


-(void) initActions{

	//reset the view controller array (i.e the array of action view controllers, which is dependent upon the current condition)
    if (actionvcsarray != nil){
        [actionvcsarray release];
        actionvcsarray = nil;
    }
    
    //reset the action subject array (i.e the array of subjects that are associated with an action)
    if (actionsubjectarray != nil){
        [actionsubjectarray release];
        actionsubjectarray = nil;
    }
    
    //reset the array of possible option associated with a particular action
    if (actionoptionsarray != nil){
        [actionoptionsarray release];
        actionoptionsarray = nil;        
    }
    
	
    //Now recreate each of these arrays.
    
	actionvcsarray = [(NSArray *) [tree objectForKey:[self currentCondition]] retain];
    
    if (actionvcsarray == nil){
        NSLog(@"action vcs is nil!!!");
    }
    
    actionvcsindex = 0;
    
    /*
     * Set the current action type (block, notify etc).
     */
	currentActionType = [actionvcsarray objectAtIndex:actionvcsindex];
    
    // NSLog(@"current action type has been set to %@", currentActionType);
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
    
	if ([tmp objectForKey:@"arguments"] != NULL){
        NSDictionary* tmpoptdict = [(NSDictionary*) [tmp objectForKey:@"arguments"] objectForKey:@"options"];
        actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
        actionoptionsarrayindex = 0;
    }
    
    /*
     * Post a notification to tell UI that the action has changed.
     */
    //NSString* controller = [self currentActionViewController];
    //NSDictionary* dict = [NSDictionary dictionaryWithObject:controller forKey:@"controller"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTypeChange" object:nil userInfo:nil];
}





-(void) mapDevicesToOwners{
    
    deviceLookup = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [subjectLookup allKeys]){
        NSArray* devices = [subjectLookup objectForKey:key];
        for (NSString *device in devices){
            [deviceLookup setObject:key forKey:device];
        }
    }
}






#pragma mark * Image lookup methods


/*
 * Private helper function
 */

-(NSString *) lookupImage:(NSString*)identity type:(NSString*)type state:(NSString*)state{
    
	NSDictionary *images = (NSDictionary *) [imageLookup objectForKey:identity];
    if (state == nil){
        return [images objectForKey:type];
    }
    NSDictionary *dict = (NSDictionary *) [images objectForKey:type];
	return [dict objectForKey:state];
}


/*
 * Dynamic images (i.e. read from config file)
 */

-(NSString *) nextSubjectOwnerImage{
	//return @"";
    return [self lookupImage: [self nextSubjectOwner] type:@"main" state:nil];
}

-(NSString *) currentSubjectOwnerImage{
    //return @"";
	return [self lookupImage: [self currentSubjectOwner] type:@"main" state:nil];
}

-(NSString *) nextSubjectDeviceImage{
    //return @"";
	return [self lookupImage: [self nextSubjectDevice] type:@"main" state:nil];
}

-(NSString *) currentSubjectDeviceImage{
    //return @"";
	return [self lookupImage: [self currentSubjectDevice] type:@"main" state:nil];
}


/*
 * Static images (i.e. local to the app...)
 */

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
    return image;
    
}

-(NSString *) nextActionImage{
	NSString *action = [self nextAction];
    NSString *image = [self lookupImage:action type:currentActionType state:@"action"];
    return image;
}

-(NSString*) getActionResultImage:(BOOL) isfired{
    
    NSDictionary *subj = (NSDictionary *) [imageLookup objectForKey:[self currentActionSubject]];
    
    NSDictionary *dict = (NSDictionary *) [subj objectForKey:[self currentActionType]];
    
    if (isfired){
        return [NSString stringWithFormat:@"%@",[dict objectForKey:@"fired"]];
    }
    
    return [NSString stringWithFormat:@"%@",[dict objectForKey:@"result"]];
}


#pragma mark * Private methods

-(void) initConditions{
    
    
   
    conditionvcsarray = (NSArray*) [[conditionvcs allValues] retain];
    conditionvcsindex = 0;
    
    /*
     * set up the default condition arguments dictionary.
     */
    for (NSString *condition in [conditionLookup allKeys]){
        NSDictionary *dictionary = [conditionLookup objectForKey:condition];
        NSDictionary *arguments = [dictionary objectForKey:@"arguments"];
        [currentConditionArguments  setObject:arguments forKey:condition];  
    }
}


-(NSString*) getDeviceOwner:(NSString *) device{
    return  [deviceLookup objectForKey:device];
}



-(NSString *) currentDeviceName{
    NSDictionary *dict = [devicemetadata objectForKey:[self currentSubjectDevice]];
    return [dict objectForKey:@"name"];
}


#pragma mark * Subject frames (private)

-(NSString *) currentSubjectDevice{
	return [devices objectAtIndex:devicesindex % [devices count]];
}

-(NSString *) nextSubjectDevice{
    NSString *device = [devices objectAtIndex:++devicesindex % [devices count]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"subjectDeviceChange" object:nil userInfo:nil];
	return device;
}

-(NSString *) currentSubjectOwner{
    
	return [subjectownership objectAtIndex:subjectownershipindex % [subjectownership count]];	
}

-(NSString *) nextSubjectOwner{
	NSString *next =  [subjectownership objectAtIndex:++subjectownershipindex % [subjectownership count]];
	[devices release];
	devices =  [[subjectLookup objectForKey:[self currentSubjectOwner]] retain];
	devicesindex = 0;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"subjectOwnerChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"subjectDeviceChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"catalogueChange" object:nil userInfo:nil];
	return next;
}

#pragma mark * Condition frames (public)

-(NSMutableDictionary *) conditionArguments/*:(NSString*) type*/{
    if ([currentConditionArguments objectForKey:[self currentCondition]] == nil){
        return [[NSMutableDictionary alloc] init];
    }
  return [currentConditionArguments objectForKey:[self currentCondition]];
}

-(void) setConditionArguments:(NSMutableDictionary *) args{
    
    NSMutableDictionary* currentArgs = [self conditionArguments];
    
 
    for (NSObject *key in [args allKeys]){
        [currentArgs setObject:[args objectForKey:key] forKey:key];
    }
    
    
    [currentConditionArguments setObject:currentArgs forKey:[self currentCondition]];
   
}

-(NSString*) currentCondition{
    NSString *condition = (NSString*) [conditions objectAtIndex:conditionindex % [conditions count]];
    return condition;
}

/*
 * When the condition changes, the associated list of permitted actions will also change. This function
 * will update the condition and regenerate the actionvcs array to populate it with the set of allowed
 * actions (derived from the conditionactiontree json object).
 */
-(NSString*) nextCondition{    
    NSString *condition = (NSString*) [conditions objectAtIndex:++conditionindex % [conditions count]];
    [self initActions];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"conditionChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"catalogueChange" object:nil userInfo:nil];
    
    return condition;
}

#pragma mark * Action frames (private)


-(NSString *) nextActionSubject{
    
    if (actionsubjectarray == NULL)
		return NULL;
	
	NSString *subject = [actionsubjectarray objectAtIndex:++actionsubjectarrayindex % [actionsubjectarray count]];
	[self updateActionOptions:subject];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionChange" object:nil userInfo:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"catalogueChange" object:nil userInfo:nil];
    
	return subject;
}

-(void) updateActionOptions:(NSString *) subject{
    if (actionoptionsarray != NULL){
        [actionoptionsarray release];
    }
    NSDictionary *tmp = [actionLookup objectForKey:currentActionType];
    if ([tmp objectForKey:@"arguments"] != NULL){
        NSDictionary* tmpoptdict = [(NSDictionary*)[tmp objectForKey:@"arguments"] objectForKey:@"options"];
        actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
        actionoptionsarrayindex = 0;
    }
}


-(NSMutableDictionary *) actionArguments/*:(NSString*) type*/{
    if ([currentActionArguments objectForKey:[self currentActionType]] == nil){
        return [[NSMutableDictionary alloc] init];
    }
    return [currentActionArguments objectForKey:[self currentActionType]];
}

-(void) setActionArguments:(NSMutableDictionary *) args{
    
    
    NSMutableDictionary* currentArgs = [self actionArguments];
    
    for (NSObject *key in [args allKeys]){
        [currentArgs setObject:[args objectForKey:key] forKey:key];
    }
    
    [currentActionArguments setObject:currentArgs forKey:[self currentActionType]];
   
}


-(NSString *) nextAction{
	if (actionoptionsarray == NULL){
		return NULL;
	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"catalogueChange" object:nil userInfo:nil];
    
	NSString* nextAction =  [actionoptionsarray objectAtIndex:++actionoptionsarrayindex % [actionoptionsarray count]];
    
    NSMutableDictionary *newargs = [[NSMutableDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:nextAction, nil] forKeys:[[NSArray alloc] initWithObjects:@"options",nil]];
    
    [self setActionArguments:newargs];
    return  nextAction;
}

-(NSString *) currentActionType{
    return currentActionType;
}

-(NSString *) currentActionSubject{
    NSString *subject = [actionsubjectarray objectAtIndex:actionsubjectarrayindex % [actionsubjectarray count]];
    return subject;
}

-(NSString *) currentActionSubjectName{
    NSDictionary *dict = [devicemetadata objectForKey:[self currentActionSubject]];
    return [dict objectForKey:@"name"];

}

-(NSString *) currentAction{
    if (actionoptionsarray == NULL)
		return NULL;
	
    
    NSString* currentAction =  [actionoptionsarray objectAtIndex:actionoptionsarrayindex % [actionoptionsarray count]];
    
    NSMutableDictionary *newargs = [[NSMutableDictionary alloc] initWithObjects:[[NSArray alloc] initWithObjects:currentAction, nil] forKeys:[[NSArray alloc] initWithObjects:@"options",nil]];
    
    [self setActionArguments:newargs];

    return currentAction;
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
        NSDictionary* tmpoptdict = [(NSDictionary *)[tmp objectForKey:@"arguments"] objectForKey:@"options"];
        actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
        actionoptionsarrayindex = 0;
	}
    
    
    
    /*
     * Notify relevant listeners of the change....
     */
    
    NSString* controller = [self currentActionViewController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionTypeChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"catalogueChange" object:nil userInfo:nil];
	return controller;
}

-(NSString *) currentActionViewController{
    return [actionvcs objectForKey:currentActionType];
}

-(NSString *) currentConditionViewController{
    return [conditionvcsarray objectAtIndex:conditionvcsindex % [conditionvcsarray count]];
}

-(NSString *) nextConditionViewController{
    
	return [conditionvcsarray objectAtIndex:++conditionvcsindex % [conditionvcsarray count]];
    
}

-(NSString*) getConditionMonitorController{
    return [conditionresultvcs objectForKey:[self currentCondition]];
}

-(NSString*) getConditionViewController{
    return [conditionvcs objectForKey:[self currentCondition]];
}



#pragma mark * Public policy setters

-(void) setSubjectDevice:(NSString*) adevice{
    
    NSString *owner = [self getDeviceOwner:adevice];
    
    NSDictionary* tmpdevices = [subjectLookup objectForKey:owner];
    int index = 0;
    
    for (NSString *device in tmpdevices){
        
        if ([device isEqualToString:adevice]){
            
            [devices release];
            devices = [tmpdevices retain];
            devicesindex = index;
            
            subjectownershipindex = 0;
            
            for (NSString * tmpowner in subjectownership){
                
                if ([tmpowner isEqualToString:owner]){
                    break;
                }
                subjectownershipindex+=1;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"subjectOwnerLoaded" object:nil userInfo:nil];
            return;
        }
        index += 1;
    }    
}

-(void) setCondition:(NSString *)condition options:(NSMutableDictionary *)options{
    
    int index = 0;
    //[currentConditionArguments removeAllObjects];
    [self setConditionArguments:options];
    
    for (NSString* acondition in conditions){
        if ([acondition isEqualToString:condition]){
            conditionindex = index;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"conditionLoaded" object:nil userInfo:nil];
        }
        index+=1;
    }
}


/*
 * Action  =   notify           /   block 
 * Subject =   mum, dad         /   device macaddr  
 * Option  =   tweet, notify    /   owner (i.e. mum/dad)
 */

//TODO:  sort out what happens when the subject does not exist in the list of subjects we know about in the catalogue...

-(void) setAction:(NSString *) action subject:(NSString*) subject options:(NSMutableDictionary*)arguments{
    
    
    
    NSLog(@"----------->> SETTING ACTION - arguments action is %@ subject is %@ args is %@", action, subject, arguments);
    
    int index = 0;
    
    [currentActionArguments removeAllObjects];
  
    //first check to see if action exists
    NSDictionary *tmp = [actionLookup objectForKey:action];
    
    
    NSLog(@"action lookup dict is %@", tmp);
    
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
                    [self setActionArguments:arguments];
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
                    
                    if (arguments != nil && [arguments count] > 0){
                        
                        if (actionoptionsarray != NULL)
                            [actionoptionsarray release];
                        
                        if ([tmp objectForKey:@"arguments"] != NULL){
                            
                            NSDictionary* tmpoptdict = [(NSDictionary*)[tmp objectForKey:@"arguments"] objectForKey:@"options"];
                            
                            /*
                             * Get the array of all possible actions from the catalogue.
                             */
                            actionoptionsarray =  [[tmpoptdict objectForKey:subject] retain];
                            
                        
                            actionoptionsarrayindex = 0;
                            
                            /*
                             * Now loop through the options to set to the argument passed in here in the dictionary
                             */
                            
                            index = 0;
                            NSString* argument = [arguments objectForKey:@"options"];
                            
                           
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
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"actionSubjectChange" object:nil userInfo:nil];
                    break;
                }
                index += 1;
            }           
        }
    }
}



@end
