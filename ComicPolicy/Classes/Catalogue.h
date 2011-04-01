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


+(NSString *) currentSubjectOwner;
+(NSString *) nextSubjectOwner;
+(NSString *) nextSubjectOwnerImage;
+(NSString *) currentSubjectDevice;
+(NSString *) nextSubjectDevice;
+(NSString *) nextSubjectDeviceImage;
+(NSString *) currentSubjectDeviceImage;
+(NSString *) nextConditionViewController;
+(NSString *) nextActionViewController;
+(NSString *) nextActionSubject;
+(NSString *) nextAction;

@end
