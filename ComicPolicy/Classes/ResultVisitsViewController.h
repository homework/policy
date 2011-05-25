//
//  ResultVisitsViewController.h
//  ComicPolicy
//
//  Created by Tom Lodge on 06/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonitorViewController.h"
#import "ASIHTTPRequest.h"
#import "NetworkManager.h"
#import <Box2D/Box2D.h>

#define PTM_RATIO 16

@interface ResultVisitsViewController : MonitorViewController <UIAccelerometerDelegate>  {
    b2World *world;
    NSTimer *tickTimer;
    NSTimer *fakeDataTimer;
    UILabel *currentLabel;
    UIImageView* cloud;
}

@property(nonatomic, retain) UIImageView* cloud;

@end
