//
//  ResultView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultView.h"


@implementation ResultView
@synthesize monitorImage;
@synthesize resultImage;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		UIImageView *tmpResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultright.png"]];
		tmpResult.frame = CGRectMake(897-459, 0, 458, 300);
		[self addSubview:tmpResult];
		self.resultImage = tmpResult;
		[tmpResult release];

		UIImageView *tmpMonitor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resultbandwidth.png"]];
		[self addSubview:tmpMonitor];
		self.monitorImage = tmpMonitor;
		[tmpMonitor release];
		
		
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
