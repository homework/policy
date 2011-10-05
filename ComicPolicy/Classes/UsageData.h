//
//  UsageData.h
//  ComicPolicy
//
//  Created by Tom Lodge on 05/10/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "timestamp.h"

@interface UsageData : NSObject {
    tstamp_t ts;
    long bytes;
}

@property(nonatomic, assign) tstamp_t ts;
@property(nonatomic, assign) long bytes;

@end
