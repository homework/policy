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

#pragma mark * Public controller getters

-(NSString *) nextActionViewController;
-(NSString *) currentActionViewController;

-(NSString *) nextConditionViewController;
-(NSString *) currentConditionViewController;
-(NSString *) getConditionResultController:(NSString*) condition;
-(NSString *) nextCondition;
-(NSString *) currentCondition;
-(NSString *) getConditionImage:(NSString *) condition;
-(NSString *) getConditionResultImage:(NSString *) condition;
-(NSString *) getConditionViewController:(NSString*)condition;
-(NSString *) currentActionSubjectImage;
-(NSString *) nextActionSubjectImage;
-(NSString *) currentActionImage; 
-(NSString *) nextActionImage;

-(NSString *) nextSubjectOwnerImage;
-(NSString *) currentSubjectOwnerImage;

-(NSString *) nextSubjectDeviceImage;
-(NSString *) currentSubjectDeviceImage;

-(NSString *) getActionResultImage:(NSString*) subject action:(NSString*)action;


-(void) setSubject:(NSString *)owner device:(NSString*) device;
-(void) setCondition:(NSString *)condition;
-(void) setAction:(NSString *) action subject:(NSString*) subject option:(NSString*)option;
    
@end
