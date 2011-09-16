//
//  ActionTimeView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 04/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionTimeView.h"


@implementation ActionTimeView
@synthesize timecaption;
@synthesize  light;
@synthesize dark;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		light = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selecthourslight.png"]];
	
        [self addSubview:light];
		[light release];
        
        dark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selecthoursdark.png"]];
        [self addSubview:dark];
        dark.alpha = 0.0;
		[dark release];
        
        
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame.png"]];
		[self addSubview:tmpframe];
		[tmpframe release];
        
        UIImageView* bottomcaptionframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"captionframe.png"]];
		bottomcaptionframe.frame = CGRectMake(143, (300-33), bottomcaptionframe.frame.size.width, bottomcaptionframe.frame.size.height);
        [self addSubview:bottomcaptionframe];
        
        self.timecaption = [[UILabel alloc] initWithFrame:CGRectMake(143,300-33, bottomcaptionframe.frame.size.width, bottomcaptionframe.frame.size.height)];
        self.timecaption.textColor = [UIColor blackColor];
        self.timecaption.textAlignment = UITextAlignmentCenter;
        self.timecaption.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:15.0];
        self.timecaption.backgroundColor = [UIColor clearColor];
        [self addSubview:timecaption];

		
		
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
