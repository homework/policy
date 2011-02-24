//
//  ConditionBandwidthView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionBandwidthView.h"


@implementation ConditionBandwidthView
@synthesize conditionImage;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bandwidth.png"]];
		self.conditionImage = tmpImage;
		[self addSubview:conditionImage];
		[tmpImage release];    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
