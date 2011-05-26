//
//  ResultTimeViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 05/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorViewController.h"
#import "MonitorTimeView.h"

@interface ResultTimeViewController : MonitorViewController {
	MonitorTimeView *monitorTimeView;
}

@property(nonatomic, retain) MonitorTimeView* monitorTimeView;

@end
