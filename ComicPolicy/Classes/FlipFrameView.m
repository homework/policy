//
//  FlipFrameView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 28/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipFrameView.h"


@implementation FlipFrameView
@synthesize upImage;

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
