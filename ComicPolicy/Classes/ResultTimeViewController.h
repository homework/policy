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

typedef enum {
    NOREADING = 0, 
    ACTIVE = 1, 
    INACTIVE = 2
}activity;

@interface ResultTimeViewController : MonitorViewController {
	MonitorTimeView *monitorTimeView;
    NSTimer *monitorTimer;
    BOOL rotateflag;
    activity currentActivity;
}

//@property(nonatomic, retain) MonitorTimeView* monitorTimeView;

@end
