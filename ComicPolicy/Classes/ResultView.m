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
@synthesize resultMainImage;
@synthesize comicframe;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		//self.autoresizingMask = UIViewAutoresizingNone;

		UIImageView *tmpResultBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dadwaiting.png"]];
		tmpResultBack.autoresizingMask = UIViewContentModeScaleAspectFit;// | UIViewAutoresizingFlexibleHeight;

		tmpResultBack.frame = CGRectMake(897-459, 0, 458, 300);
		[self addSubview:tmpResultBack];
		self.resultMainImage = tmpResultBack;
		[tmpResultBack release];
		
		UIImageView *tmpMonitor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resulttype.png"]];
		tmpMonitor.autoresizingMask = UIViewContentModeScaleAspectFit;// UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[self addSubview:tmpMonitor];
		self.monitorImage = tmpMonitor;
		[tmpMonitor release];
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigframe.png"]];
		self.comicframe = tmpframe;
		tmpframe.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[self addSubview:tmpframe];
		[tmpframe release]; 
		
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
