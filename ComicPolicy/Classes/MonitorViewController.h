//
//  MonitorViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 05/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MonitorView.h"
#import <Box2D/Box2D.h>
#define PTM_RATIO 16

@interface MonitorViewController : UIViewController <UIAccelerometerDelegate>{
    MonitorView* monitorView;
   
    b2World *world;
    NSTimer *tickTimer;
}

@property(nonatomic,retain) MonitorView *monitorView;
@property(nonatomic,retain) NSString* currentMonitorScene;
@property(nonatomic,retain) UIImageView* testImage;
@end
