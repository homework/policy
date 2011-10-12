//
//  ConditionTimeViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootConditionTimeViewController.h"

@interface ConditionTimeViewController : RootConditionTimeViewController {
	NSArray* days;
    NSArray* dayLabels;
     bool selected[7];
}



@end
