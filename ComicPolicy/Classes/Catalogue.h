//
//  Catalogue.h
//  ComicPolicy
//
//  Created by Tom Lodge on 31/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface Catalogue : NSObject {
    NSMutableDictionary *currentConditionArguments;
    
}

@property(nonatomic, retain) NSMutableDictionary *currentConditionArguments;

+ (Catalogue *)sharedCatalogue;

#pragma mark * Public controller getters for UI

#pragma mark *subject getters for UI
-(NSString *) currentSubjectOwnerImage;
-(NSString *) nextSubjectOwnerImage;
-(NSString *) currentSubjectDeviceImage;
-(NSString *) nextSubjectDeviceImage;
-(NSString *) currentDeviceName;

#pragma mark *action getters for UI
-(NSString *) currentActionViewController;
-(NSString *) nextActionViewController;
-(NSString *) currentActionImage; 
-(NSString *) nextActionImage;
-(NSString *) currentActionSubjectImage;
-(NSString *) nextActionSubjectImage;

#pragma mark *condition getters for UI
-(NSString *) currentConditionViewController;
-(NSString *) nextConditionViewController;
-(NSString *) getConditionImage;
-(NSString *) getConditionViewController;
//-(NSMutableDictionary *) conditionArgumentsForType:(NSString*) type;
-(NSMutableDictionary *) conditionArguments; /*:(NSString*) type;*/

#pragma mark *result images 
-(NSString *) getActionResultImage:(BOOL) isfired;
-(NSString *) getConditionResultController;
-(NSString *) getConditionResultImage;


#pragma mark *policy getters

-(NSString *) currentSubjectDevice;
-(NSString *) currentSubjectOwner;

-(NSString *) currentCondition;
-(NSString *) nextCondition;
-(NSString *) currentAction;
-(NSString *) currentActionSubject;
-(NSString *) currentActionType;


-(void) setSubject:(NSString *)owner device:(NSString*) device;
-(void) setCondition:(NSString *)condition options:(NSDictionary*) options;
-(void) setAction:(NSString *) action subject:(NSString*) subject options:(NSArray*)options;
-(void) setConditionArguments:(NSMutableDictionary *) args;
-(void) parseCatalogue:(NSString*) catalogue;

@end
