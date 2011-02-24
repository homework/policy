//
//  EventViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionView.h"
#import "ConditionBandwidthViewController.h"
#import "Lookup.h"

@interface RootConditionViewController : UIViewController {
	ConditionView* conditionView; ///change to controller eventually...
	ConditionBandwidthViewController *conditionBandwidthViewController;
	//ConditionBandwidthView* conditionBandwidthView;
}

@property(nonatomic,retain) ConditionView *conditionView;

@property(nonatomic,retain) ConditionBandwidthViewController *conditionBandwidthViewController;
//@property(nonatomic,retain) ConditionBandwidthView *conditionBandwidthView;

@end
