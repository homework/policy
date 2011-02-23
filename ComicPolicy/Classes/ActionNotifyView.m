//
//  ActionView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionNotifyView.h"


@implementation ActionNotifyView
@synthesize personImage;
@synthesize notifyImage;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		notifyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notifyby.png"]];
		notifyImage.frame = CGRectMake(0, (300-142), 295, 142);
		[self addSubview:notifyImage];
		
		personImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notifydad.png"]];
		[self addSubview:personImage];		
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
