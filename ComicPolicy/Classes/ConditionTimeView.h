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
	UIImageView *fromHourHand;
	UIImageView *fromMinuteHand;
	UIImageView *toHourHand;
	UIImageView *toMinuteHand;
	UIView *fromClockFace;
	UIView *toClockFace;
	
	CGAffineTransform initialTransform ;
	float currentValue;
	
	HandView *fromHourView;
	HandView *fhh;
	CGRect clockFromFrame;
	CGRect clockToFrame;
}


@property CGAffineTransform initialTransform;
@property float currentValue;


@property(nonatomic, retain) UIImageView *fromHourHand;
@property(nonatomic, retain) UIImageView *fromMinuteHand;
@property(nonatomic, retain) UIImageView *toHourHand;
@property(nonatomic, retain) UIImageView *toMinuteHand;
@property(nonatomic, retain) UIView *fromClockFace;
@property(nonatomic, retain) UIView *toClockFace;
@property(nonatomic, retain) HandView *fromHourView;
@end
