//
//  ConditionTimeView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 01/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FrameView.h"
#import "HandView.h"

@interface ConditionTimeView : FrameView {
	UIView *fromClockFace;
	UIView *toClockFace;
    
	HandView *fhh;
	HandView *fmh;
	HandView *thh;
	HandView *tmh;
	
	CGRect clockFromFrame;
	CGRect clockToFrame;
    
    int hour;
    int minute;
    
    UIButton* fromAMPM;
    UIButton* toAMPM;

}

@property(nonatomic, retain) UIView *fromClockFace;
@property(nonatomic, retain) UIView *toClockFace;
@property(nonatomic, retain) HandView *fhh;
@property(nonatomic, retain) HandView *fmh;
@property(nonatomic, retain) HandView *thh;
@property(nonatomic, retain) HandView *tmh;
@property(nonatomic, retain) UIButton* fromAMPM;
@property(nonatomic, retain) UIButton* toAMPM;

@end
