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

@interface RootActionViewController : UIViewController {
	UIViewController* currentViewController;
	NSArray* controllerList;
	int controllerIndex;	
}

@end
