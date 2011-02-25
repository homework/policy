//
//  Lookup.h
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Lookup : NSObject {
	
}

+(NSString *) lookupmonitor: (NSString *) conditionscene;
+(NSString *) lookupresult: (NSString *) actionscene;
+(NSString *) nextConditionImage;
+(NSString *) nextPeopleImage;
+(NSString *) nextDeviceImage;
+(NSString *) nextNotifyPersonImage;
+(NSString *) nextNotifyByImage;

@end
