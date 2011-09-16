//
//  HandView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 02/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HandView.h"

@implementation HandView



-(id) initWithFrameAndImage:(CGRect)frame image:(NSString *)image{
	if ((self = [super initWithFrame:frame])) {
		UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
		background.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
		//self.backgroundColor = [UIColor cyanColor];
		[self addSubview: background];
		[self.layer setAnchorPoint:CGPointMake(0.5, 0.9)]; 
		[background release];
        
       	}
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
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
