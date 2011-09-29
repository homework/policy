//
//  ResultView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 23/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultView.h"


@implementation ResultView
//@synthesize monitorWebView;
//@synthesize monitorImage;
@synthesize resultMainImage;
//@synthesize comicframe;
//@synthesize activityIndicatorView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		
       
		//[self setBackgroundColor:[UIColor redColor]];
		//[self setBackgroundColor: [[UIColor alloc] initWithRed:243.0 / 255 green:242.0 / 255 blue:241.0 / 255 alpha:1.0]];
        
        /*UIView *aview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [aview setBackgroundColor:[UIColor redColor]];
        [self addSubview:aview];
        [aview release];*/
        
        /*UIImageView *tmpResultBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dadwaiting.png"]];
		tmpResultBack.autoresizingMask =  UIViewContentModeScaleAspectFit | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		tmpResultBack.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		[self addSubview:tmpResultBack];
		self.resultMainImage = tmpResultBack;
		[tmpResultBack release];*/
		
		
		/*UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigframe.png"]];
		tmpframe.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
		tmpframe.autoresizingMask = UIViewContentModeScaleAspectFit | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[self addSubview:tmpframe];
		[tmpframe release]; */
		
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
