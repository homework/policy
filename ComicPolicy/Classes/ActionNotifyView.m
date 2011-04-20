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


- (id)initWithFrameAndImages:(CGRect)frame topImage:(NSString *) topImage bottomImage:(NSString *) bottomImage{
    if ((self = [super initWithFrame:frame])) {
		notifyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bottomImage]];
		notifyImage.frame = CGRectMake(0, (300-128), 295, 142);
		[self addSubview:notifyImage];
		
	
		personImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:topImage]];
		personImage.frame = CGRectMake(0, 14, 295, 160);
		[self addSubview:personImage];		
		
		UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame2.png"]];
		[self addSubview:tmpframe];
		[tmpframe release]; 
		
		upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenup.png"]];
		upImage.frame = CGRectMake(135, 4, 27, 26);
		[self addSubview:upImage];
				
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
