//
//  ResultViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 05/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultView.h"
#import "MonitorView.h"

@interface ResultViewController : UIViewController {
	NSString* currentMonitorScene;
	NSString* currentActionScene;
	ResultView* resultView;
	MonitorView* monitorView;
}

@property(nonatomic,retain) ResultView *resultView;
@property(nonatomic,retain) MonitorView *monitorView;
@property(nonatomic,retain) NSString* currentMonitorScene;
@property(nonatomic,retain) NSString* currentActionScene;
@end
