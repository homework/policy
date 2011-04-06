//
//  MonitorView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 06/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MonitorView.h"


@implementation MonitorView
@synthesize monitorImage;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		UIImageView *whiteMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whitemask.png"]];
		whiteMask.frame = CGRectMake(439, 0, 130, 298);
		[self addSubview:whiteMask];
		[whiteMask release];
		
        UIImageView *tmpMonitor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resulttype.png"]];
		tmpMonitor.autoresizingMask = UIViewContentModeScaleAspectFit;// UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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