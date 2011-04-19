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
-(void) updateActionSelections:(NSString *)subject;
-(void) initActions;
-(NSString *) lookupImage:(NSString*)identity state:(NSString*)state;
-(NSString *) currentSubjectOwner;
-(NSString *) nextSubjectOwner;
-(NSString *) nextSubjectOwnerImage;
-(NSString *) currentSubjectDevice;
-(NSString *) nextSubjectDevice;
-(NSString *) nextSubjectDeviceImage;
-(NSString *) currentSubjectDeviceImage;
-(NSString *) nextConditionViewController;
-(NSString *) nextActionViewController;
-(NSString *) currentActionSubject;
-(NSString *) nextActionSubject;
-(NSString *) currentActionSubjectImage;
-(NSString *) nextActionSubjectImage;
-(NSString *) nextAction;
-(NSString *) currentAction;
-(NSString *) currentActionImage;
-(NSString *) nextActionImage;

-(NSString*)  nextCondition;
-(NSString*) nextConditionImage;
-(NSString *) getConditionImage:(NSString*)condition;
-(NSString *) getConditionResult:(NSString*)condition;


-(NSString *) lookupmonitor: (NSString *) conditionscene;
-(NSString *) lookupmonitorvc: (NSString *) conditionscene;
-(NSString *) lookupresult: (NSString *) actionscene;
	
@end
