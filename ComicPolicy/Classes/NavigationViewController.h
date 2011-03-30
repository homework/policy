//
//  NavigationViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 30/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"

@interface NavigationViewController : UIViewController {
	NavigationView *navigationView;
	UIView *selectedView;
	int selectedPolicy;
}

-(void) updatePolicyIds:(NSMutableArray *) policyids;
@end
