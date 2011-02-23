//
//  EventViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConditionView.h"

@interface ConditionViewController : UIViewController {
	ConditionView* conditionView;
	NSMutableArray *conditionImages;
	int conditionImageIndex ;
}

@end
