//
//  ConditionTypeView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConditionTypeView.h"


@implementation ConditionTypeView

@synthesize conditionImage;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UIImageView *tmpImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"surfing.png"]];
		self.conditionImage = tmpImage;
		[self addSubview:conditionImage];
		[tmpImage release];
    }
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
