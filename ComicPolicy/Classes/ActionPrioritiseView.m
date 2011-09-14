//
//  ActionPrioritiseView.m
//  ComicPolicy
//
//  Created by Tom Lodge on 09/09/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionPrioritiseView.h"


@implementation ActionPrioritiseView


- (id)initWithFrameAndImage:(CGRect)frame topImage:(NSString*)topImage{
	if ((self = [super initWithFrame:frame])) {
        
        UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"priority.png"]];
        
		background.frame = CGRectMake(background.frame.origin.x, background.frame.origin.y + 13, background.frame.size.width, background.frame.size.height);
		
        [self addSubview:background];	
        
        UIImageView* tmpframe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame2.png"]];
		[self addSubview:tmpframe];
		[tmpframe release]; 
        
        upImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenup.png"]];
		upImage.frame = CGRectMake(135, 4, 27, 26);
		[self addSubview:upImage];
        
        deviceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:topImage]];
		deviceImage.frame = CGRectMake(0, 14, 295, 160);
		[self addSubview:deviceImage];

        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
