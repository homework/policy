//
//  ResultView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultView.h"


@implementation ResultView
@synthesize monitorWebView;
@synthesize monitorImage;
@synthesize resultMainImage;
@synthesize comicframe;
@synthesize activityIndicatorView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		
        self.backgroundColor = [UIColor yellowColor];
		/*
		UIImageView *tmpResultBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dadwaiting.png"]];
		tmpResultBack.autoresizingMask = UIViewContentModeScaleAspectFit;// | UIViewAutoresizingFlexibleHeight;

		tmpResultBack.frame = CGRectMake(897-459, 0, 458, 300);
		[self addSubview:tmpResultBack];
		self.resultMainImage = tmpResultBack;
		[tmpResultBack release];*/
		
		/*UIActivityIndicatorView *tmpIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		tmpIndicatorView.frame = CGRectMake(210,130,40,40);
		[self addSubview:tmpIndicatorView];
		self.activityIndicatorView = tmpIndicatorView;
		[tmpIndicatorView release];*/
		
											
		/*UIImageView *tmpMonitor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"resulttype.png"]];
		tmpMonitor.autoresizingMask = UIViewContentModeScaleAspectFit;// UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self addSubview:tmpMonitor];
		self.monitorImage = tmpMonitor;
		[tmpMonitor release];		*/
		
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigframe.png"]];
		self.comicframe = tmpframe;
		tmpframe.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		//[self addSubview:tmpframe];
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
