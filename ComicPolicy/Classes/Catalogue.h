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
    
}


+ (Catalogue *)sharedCatalogue;

#pragma mark * Public controller getters for UI

#pragma mark *subject getters for UI
-(NSString *) currentSubjectOwnerImage;
-(NSString *) nextSubjectOwnerImage;
-(NSString *) currentSubjectDeviceImage;
-(NSString *) nextSubjectDeviceImage;


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


#pragma mark *result images 
-(NSString *) getActionResultImage;//:(NSString*) subject action:(NSString*)action;
-(NSString *) getConditionResultController;
-(NSString *) getConditionResultImage;


#pragma mark *policy getters

-(NSString *) currentSubjectDevice;
-(NSString *) currentCondition;
-(NSString *) nextCondition;
-(NSString *) currentAction;
-(NSString *) currentActionSubject;
-(NSString *) currentActionType;


-(void) setSubject:(NSString *)owner device:(NSString*) device;
-(void) setCondition:(NSString *)condition;
-(void) setAction:(NSString *) action subject:(NSString*) subject option:(NSString*)option;
    
@end
