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

@interface ResultBandwidthViewController : MonitorViewController{
    b2World *world;
    NSTimer *tickTimer;
    NSTimer *fakeDataTimer;
    UIView *topMask;
    UILabel *caption;
    int bagindex;
}

@property(nonatomic, assign) UIView* topMask;
@property(nonatomic, retain) UILabel* caption;

@end
