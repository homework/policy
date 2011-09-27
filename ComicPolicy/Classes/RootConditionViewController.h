//
//  EventViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionBandwidthViewController.h"
@class ConditionVisitingViewController;

@interface RootConditionViewController : UIViewController {
	ConditionViewController* currentViewController;
	NSArray* controllerList;
	int controllerIndex;
}

@property(nonatomic, retain) ConditionViewController* currentViewController;

@end
