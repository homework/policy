//
//  ConditionBandwidthView.h
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameView.h"

@interface ConditionBandwidthView : FrameView {
	UIImageView* moneyImage;
	UILabel *bandwidthLabel;
}

@property(nonatomic,retain) UIImageView *moneyImage;

@property(nonatomic,retain) UILabel *bandwidthLabel;

@end
