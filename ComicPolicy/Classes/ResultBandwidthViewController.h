//
//  ResultBandwidthViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 16/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorViewController.h"
#import "ASIHTTPRequest.h"
#import "NetworkManager.h"
#import <Box2D/Box2D.h>
#define PTM_RATIO 16

@interface ResultBandwidthViewController : MonitorViewController  <UIAccelerometerDelegate> {
    b2World *world;
    NSTimer *tickTimer;
    NSTimer *fakeDataTimer;
    UIView *topMask;
}

@property(nonatomic, retain) UIView* topMask;

@end
