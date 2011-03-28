//
//  ComicNavigationController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 28/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"

@interface ComicNavigationController : UIViewController {
	NSMutableArray *buttons;
}

@property(nonatomic, retain) NSMutableArray* buttons;

@end
