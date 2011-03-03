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
}


@property(nonatomic, retain) UIImageView *toMinuteHand;
@property(nonatomic, retain) UIView *fromClockFace;
@property(nonatomic, retain) UIView *toClockFace;

@end
