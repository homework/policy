//
//  MonitorViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 05/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorView.h"

@interface MonitorViewController : UIViewController {
    MonitorView* monitorView;
}

@property(nonatomic,retain) MonitorView *monitorView;
@property(nonatomic,retain) NSString* currentMonitorScene;

@end
