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
-(NSString *) nextConditionViewController;
-(NSString *) getConditionResultController:(NSString*) condition;
-(NSString *) nextConditionImage;
-(NSString *) getConditionImage:(NSString *) condition;
-(NSString *) getConditionResultImage:(NSString *) condition;
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

    
@end
