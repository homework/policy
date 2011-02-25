//
//  ActionViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ActionNotifyView.h"
#import "Lookup.h"

@interface ActionViewController : UIViewController {
	ActionNotifyView* actionNotifyView;
	NSMutableArray *personImages;
	NSMutableArray *notifyImages;
	int notifyImageIndex;
	int personImageIndex;
}

@end
