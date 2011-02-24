//
//  ConditionTypeViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionTypeView.h";

@interface ConditionTypeViewController : UIViewController {
	ConditionTypeView* conditionTypeView;
}

@property(nonatomic,retain) ConditionTypeView *conditionTypeView;

@end
